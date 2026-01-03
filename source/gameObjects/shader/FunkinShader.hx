package gameObjects.shader;

import flixel.addons.display.FlxRuntimeShader;

/**
 * Modified runtime shader to prevent crashes.

 * Taken from NMV 1.0 - https://github.com/DuskieWhy/NightmareVision/blob/main/source/funkin/backend/FunkinShader.hx
 */
class FunkinRuntimeShader extends flixel.addons.display.FlxRuntimeShader
{
	override function __createGLProgram(vertexSource:String, fragmentSource:String):lime.graphics.opengl.GLProgram
	{
		try
		{
			return super.__createGLProgram(vertexSource, fragmentSource);
		}
		catch (error)
		{
			trace("Shader crash: " + error.toString());
			@:privateAccess return super.__createGLProgram(vertexSource, FunkinShader._templateFrag);
		}
	}
}

/**
 * Modified runtime shader to prevent crashes.
 */
class FunkinShader extends flixel.graphics.tile.FlxGraphicsShader
{
	override function __createGLProgram(vertexSource:String, fragmentSource:String):lime.graphics.opengl.GLProgram
	{
		try
		{
			return super.__createGLProgram(vertexSource, fragmentSource);
		}
		catch (error)
		{
			trace("Shader crash: " + error.toString());
			
			return super.__createGLProgram(vertexSource, _templateFrag);
		}
	}
	
	public function toString()
	{
		return 'FunkinShader';
	}
	
	/**
		fallback fragment shader to be used in case of error
	**/
	static final _templateFrag:String = @:privateAccess	FlxRuntimeShader.BASE_FRAGMENT_HEADER
		+ "
		void main() 
        {
			gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		}

    ";
}