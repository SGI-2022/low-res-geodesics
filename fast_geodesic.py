# Python port of pairwise_sparse_geodesic

import cvxpy as cp
import numpy as np
import scipy as sp
import gpytoolbox as gpt

# verts: (num_verts, 3)
# faces: (num_faces, 3)
# basis: (num_verts, num_basis_vectors)
# Both num_vert_samples and num_face_samples are both optional, and will restrict the
# all calculations to only considering a random subset of all possible verts/faces.
# Note: I'm not 100% convinced the random faces work properly with the gradient. Best
# only to use num_vert_samples for now.
def fast_geodesic(verts, faces, basis, num_vert_samples=None, num_face_samples=None):

    # CVX cant tell that this basis is real-valued, so we have to promise it is
    basis = cp.real(basis)

    num_verts = len(verts)
    num_faces = len(faces)
    num_basis_vectors = basis.shape[1]

    rng = np.random.default_rng()

    # grad: (3*num_faces, num_verts)
    grad = gpt.grad(verts, faces)

    if num_vert_samples is not None:
        # If passed a number of verts to sample, choose that many verticies and restruct the basis and gradient
        # to those memembers.
        if num_vert_samples > num_verts:
            raise Exception(f'Tried to sample {num_vert_samples} verticies but there are only {num_verts}')
        chosen_verts = rng.choice(num_verts, num_vert_samples, replace=False)
        basis = basis[chosen_verts]
        grad = grad[:, chosen_verts]
        num_verts = num_vert_samples

    if num_face_samples is not None:
        # If passed a number of faces to sample, choose that many faces and restrict the gradient to
        # those members.
        if num_face_samples > num_faces:
            raise Exception(f'Tried to sample {num_face_samples} faces but there are only {num_faces}')
        chosen_faces = rng.choice(num_faces, num_face_samples, replace=False)
        chosen_grad = np.concatenate((chosen_faces, chosen_faces + num_faces, chosen_faces + 2*num_faces))
        grad = grad[chosen_grad, :]
        num_faces = num_face_samples

    # Define our optimization variable
    # distance: (num_basis_vectors, num_basis_vectors) 
    distance = cp.Variable((num_basis_vectors, num_basis_vectors), symmetric=True)

    # A weight function for integration over the surface in the basis space
    # weights: (num_basis_vectors, num_basis_vectors)
    ones = np.ones(num_verts)
    weights = (basis.T @ ones) @ (ones.T @ basis)

    # Maximize the integral of distance over the surface
    func = cp.Maximize((cp.sum(cp.multiply(distance, weights))))

    # Project the distance onto the sampled space
    projected_distance = basis @ distance @ basis.T

    # The distance along the diagonal (from a point to itself) must be less than or equal to zero.
    boundary_constraint = cp.diag(projected_distance) <= 0

    # Set up our list of constraints.
    constraints = [ boundary_constraint ]

    # The gradient along each face for each geodesic must be less than or equal to one.
    # Each target point will get it's own constraint.
    for vert_index in range(num_verts):
        
        # Grab the matrix column coresponding to the scalar function of distance to the chosen
        # target vertex.
        # vert_distance: (num_verts)
        vert_distance = projected_distance[vert_index]

        # Compute the per-face gradient of that function. 
        # vert_distance_grad: (3, num-faces)
        vert_distance_grad = cp.reshape(grad @ vert_distance, (3, num_faces))

        # Compute the per-face norm of the gradient.
        # vert_distance_grad_norm: (num-faces)
        vert_distance_grad_norm = cp.pnorm(vert_distance_grad, p=2, axis=0)

        # Restrict the gradient to be less than or equal to one.
        gradient_constraint = vert_distance_grad_norm <= 1
        constraints.append(gradient_constraint)

    # Set up the optimization problem.
    # Note: In MATLAB, we configured the solve to be really fast. Still need to do that here,
    # eg. lower precision and allow less accurate results.
    problem = cp.Problem(func, constraints)
    result = problem.solve(verbose=True)

    print(result)

    return distance.value

def laplacian_basis(verts, faces, num_basis_vectors):

    # Get the laplacian from GPyToolbox
    laplacian = gpt.cotangent_laplacian(verts, faces)

    # Return the k smallest eigenvectors (verts, num_basis_vectors)
    # Solves the generalized eigenvalue problem
    eigen_vals, eigen_vecs = sp.sparse.linalg.eigs(laplacian, k=num_basis_vectors, which='SM')

    return eigen_vecs

if __name__ == "__main__":
    verts, faces = gpt.read_mesh("data/spot_mini.obj")

    basis = laplacian_basis(verts, faces, 20)

    distance = fast_geodesic(verts, faces, basis, num_vert_samples=100)

    print(distance)
