package aerys.minko.scene.debug
{
	import aerys.minko.render.state.BlendingStyle;
	import aerys.minko.render.Viewport3D;
	import aerys.minko.render.renderer.IRenderer3D;
	import aerys.minko.render.state.BlendingDestination;
	import aerys.minko.render.state.BlendingSource;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.render.state.RenderStatesManager;
	import aerys.minko.render.state.TriangleCulling;
	import aerys.minko.render.visitor.IScene3DVisitor;
	import aerys.minko.scene.DisplayObject3D;
	import aerys.minko.scene.material.NativeMaterial3D;
	import aerys.minko.scene.mesh.primitive.CubeMesh;
	
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display3D.Context3DTriangleFace;
	
	public class DebugBox3D extends DisplayObject3D
	{
		public function DebugBox3D(color : uint = 0xff0000)
		{
			var shape : Shape = new Shape();
			
			shape.graphics.lineStyle(4, color, 1., false, "normal", CapsStyle.SQUARE);
			shape.graphics.beginFill(0, 0.);
			shape.graphics.drawRect(2, 2, 252, 252);
			
			var mat : NativeMaterial3D = NativeMaterial3D.fromDisplayObject(shape, 256, true);
			
			mat.blendMode = BlendingStyle.ADDITIVE;
				
			super(CubeMesh.cubeMesh, mat);
		}
		
		override public function visited(visitor : IScene3DVisitor) : void
		{
			var renderer : IRenderer3D	= visitor.renderer;
			
			if (renderer.isReady)
			{
				var renderStates	: RenderStatesManager	= renderer.states;

				renderStates.push(RenderState.TRIANGLE_CULLING);
				renderStates.triangleCulling = TriangleCulling.DISABLED;
				
				super.visited(visitor);
				
				renderStates.pop();
			}
		}
	}
}