import polyscope as ps
import gpytoolbox as gpt

ps.init()

verts, faces, _, _, _, _, = gpt.read_mesh("../spot.obj")

ps.register_surface_mesh("my mesh", verts, faces, smooth_shade=True)

ps.show()
