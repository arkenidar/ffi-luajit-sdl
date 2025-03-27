--[[
   Copyright 2025 Dario Cangialosi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

function load_obj_file(file_path)
  local triangles = {}
  local lines_iterator
  if love then
    lines_iterator = love.filesystem.lines(file_path)
  else
    lines_iterator = io.lines(file_path)
  end
  local index_vertex = {}
  local index_vertex_normal = {}
  for line in lines_iterator do
    local type = line:match "(%S+) .+"
    if type == "v" then
      -- vertex
      local x, y, z = line:match "v (%S+) (%S+) (%S+)"
      local vertex = { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
      table.insert(index_vertex, vertex)
    elseif type == "vn" then
      -- vertex normal
      local x, y, z = line:match "vn (%S+) (%S+) (%S+)"
      local vertex_normal = { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
      table.insert(index_vertex_normal, vertex_normal)
    elseif type == "f" then
      -- face (it's specific for triangulated-mesh: exactly 3 vertices)
      local v1, vn1, v2, vn2, v3, vn3 = line:match "f (%d+)//(%d+) (%d+)//(%d+) (%d+)//(%d+)"
      local triangle = { index_vertex[tonumber(v1)],
        index_vertex[tonumber(v2)], index_vertex[tonumber(v3)] }
      -- do vertex copy (no "shared vertex" problems with setting different "normals", collision)
      --[[bugfix. no shared vertices causing over-writing of normals. simple way, so no need to rewrite other parts of the program.]]
      ---[[
      local function vertex_copy(vertex)
        return { x = vertex.x, y = vertex.y, z = vertex.z }
      end
      triangle = { vertex_copy(triangle[1]), vertex_copy(triangle[2]), vertex_copy(triangle[3]), }
      --]]
      -- normals
      triangle[1].normal = index_vertex_normal[tonumber(vn1)]
      triangle[2].normal = index_vertex_normal[tonumber(vn2)]
      triangle[3].normal = index_vertex_normal[tonumber(vn3)]
      table.insert(triangles, triangle)
    end
  end
  return triangles
end

function load_obj_file_2(file_path)
  local triangles = {}
  local lines_iterator
  if love then
    lines_iterator = love.filesystem.lines(file_path)
  else
    lines_iterator = io.lines(file_path)
  end
  local indexable_vertex_position_xyz = {}
  local indexable_vertex_normal_xyz = {}
  for line in lines_iterator do
    local type = line:match "(%S+) .+"
    if type == "v" then
      -- vertex
      local x, y, z = line:match "v (%S+) (%S+) (%S+)"
      local vertex_position_xyz = { tonumber(x), tonumber(y), tonumber(z) }
      table.insert(indexable_vertex_position_xyz, vertex_position_xyz)
    elseif type == "vn" then
      -- vertex normal
      local x, y, z = line:match "vn (%S+) (%S+) (%S+)"
      local vertex_normal_xyz = { tonumber(x), tonumber(y), tonumber(z) }
      table.insert(indexable_vertex_normal_xyz, vertex_normal_xyz)
    elseif type == "f" then
      -- face (it's specific for triangulated-mesh: exactly 3 vertices)
      local v1, vn1, v2, vn2, v3, vn3 = line:match "f (%d+)//(%d+) (%d+)//(%d+) (%d+)//(%d+)"
      local triangle = {}
      triangle.vertex_position_indices = { tonumber(v1), tonumber(v2), tonumber(v3) }
      triangle.vertex_normal_indices = { tonumber(vn1), tonumber(vn2), tonumber(vn3) }
      table.insert(triangles, triangle)
    end
  end
  return { triangles, indexable_vertex_position_xyz, indexable_vertex_normal_xyz }
end
