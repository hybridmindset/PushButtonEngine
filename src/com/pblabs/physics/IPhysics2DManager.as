package com.pblabs.physics
{
	import com.pblabs.rendering2D.ISpatialManager2D;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface IPhysics2DManager extends ISpatialManager2D
	{
		function get scale():Number;
		function set scale(value:Number):void;
		function get allowSleep():Boolean;
		function set allowSleep(value:Boolean):void;
		function get gravity():Point;
		function set gravity(value:Point):void;
		function get worldBounds():Rectangle;
		function set worldBounds(value:Rectangle):void;
		function get visualDebugging():Boolean;
		function set visualDebugging(value:Boolean):void;
	}
}