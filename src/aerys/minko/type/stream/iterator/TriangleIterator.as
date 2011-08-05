package aerys.minko.type.stream.iterator
{
	import aerys.minko.ns.minko;
	import aerys.minko.scene.node.mesh.IMesh;
	import aerys.minko.type.stream.IndexStream;
	import aerys.minko.type.stream.VertexStream;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * Triangle3DIterator allow per-triangle access on VertexBuffer3D and
	 * IndexBuffer3D objects.
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class TriangleIterator extends Proxy
	{
		use namespace minko;
		
		private var _shallow	: Boolean				= true;
		
		private var _offset		: int					= 0;
		private var _index		: int					= 0;
		
		private var _vb			: VertexStream		= null;
		private var _ib			: IndexStream			= null;
		
		private var _triangle	: TriangleReference	= null;
		
		public function get length() : int
		{
			return _ib ? _ib.length / 3. : _vb.length / 3.;
		}
		
		public function TriangleIterator(myVertexBuffer 	: VertexStream,
										   myIndexBuffer	: IndexStream,
										   myShallow		: Boolean = true)
		{
			super();
			
			_vb = myVertexBuffer;
			_ib = myIndexBuffer;
			_shallow = myShallow;
		}
		
		override flash_proxy function hasProperty(name : *) : Boolean
		{
			return int(name) < _ib.length / 3;
		}
		
		override flash_proxy function nextNameIndex(index : int) : int
		{
			index -= _offset;
			_offset = 0;
			
			return index < _ib.length / 3 ? index + 1 : 0;
		}
		
		override flash_proxy function nextName(index : int) : String
		{
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index : int) : *
		{
			_index = index - 1;
			
			if (!_shallow || !_triangle)
				_triangle = new TriangleReference(_vb, _ib, _index);
			
			if (_shallow)
			{
				_triangle._index = _index;
				_triangle.v0._index = _ib._indices[int(_index * 3)];
				_triangle.v1._index = _ib._indices[int(_index * 3 + 1)];
				_triangle.v2._index = _ib._indices[int(_index * 3 + 2)];
				_triangle._update = TriangleReference.UPDATE_ALL;
			}
					
			return _triangle;
		}
		
		override flash_proxy function getProperty(name : *) : *
		{
			return new TriangleReference(_vb, _ib, int(name));
		}
		
		override flash_proxy function deleteProperty(name : *) : Boolean
		{
			var index 			: int 			= int(name);
			var deletedIndices 	: Vector.<int> 	= _ib.deleteFaceByIndex(index);
			
			if (deletedIndices)
			{
				/*var delete0 : Boolean = true;
				var delete1 : Boolean = true;
				var delete2 : Boolean = true;
				var indices : Vector.<int> = _ib._indices;
				var numIndices : int = indices.length;
				
				for (var i : int = 0;
					(delete0 || delete1 || delete2) && i < numIndices;
					++i)
				{
					delete0 &&= indices[i] != deletedIndices[0];
					delete1 &&= indices[i] != deletedIndices[1];
					delete2 &&= indices[i] != deletedIndices[2];
				}*/
				
				// TODO: delete useless vertices
				
				
				if (index <= _index)
					++_offset;
				
				return true;
			}
			
			return false;
		}
	}
}