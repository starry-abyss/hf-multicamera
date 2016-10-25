package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var gameCamera: FlxCamera;
	var uiCamera: FlxCamera;
	
	var sprite1: FlxSprite = new FlxSprite();
	var sprite2: FlxSprite = new FlxSprite();
	var sprite3: FlxSprite = new FlxSprite();
	
	var tilemap1: FlxTilemap = new FlxTilemap();
	
	var group1: FlxGroup = new FlxGroup();
	var group2: FlxGroup = new FlxGroup();
	
	var uiScrolling: Bool = false;
	var uiScrollingPoint: FlxPoint = new FlxPoint();
	
	var info: FlxText;
	
	override public function create():Void
	{
		super.create();
		
/*#if debug
		FlxG.debugger.drawDebug = true;
#end*/

		//gameCamera = new FlxCamera(cameraMargin, cameraMargin, Std.int(FlxG.stage.width - cameraMargin * 4), Std.int(FlxG.stage.height - cameraMargin * 4));
		gameCamera = new FlxCamera(100, 100, 500, 500);
		
		uiCamera = new FlxCamera();
		
		// for debug draw
		var cameraBorder: FlxSprite = new FlxSprite(gameCamera.x, gameCamera.y);
		cameraBorder.makeGraphic(Std.int(gameCamera.width), Std.int(gameCamera.height), FlxColor.BLACK);
		cameraBorder.updateHitbox();
		
		var hint: FlxText = new FlxText(650, 100, 550, 
		"This is a camera demo.\n\nScroll mouse wheel to zoom.\n\nPress arrow keys to scroll camera.\n\nPress SPACE to reset values.",
		24
		);
		hint.color = FlxColor.BLACK;
		
		info = new FlxText(650, hint.height + 150, 550, 
		"",
		24
		);
		info.color = FlxColor.BLACK;
		
		
		sprite1.makeGraphic(300, 300, FlxColor.BLUE);
		sprite1.updateHitbox();
		sprite2.makeGraphic(200, 200, FlxColor.RED);
		sprite2.updateHitbox();
		sprite2.reset(-30, -30);
		sprite3.makeGraphic(100, 100, FlxColor.GREEN);
		sprite3.updateHitbox();
		sprite3.reset(30, 30);
		
		
		var tiles = [];
		for (x in 0...20)
		for (y in 0...20)
		{
			tiles[y * 20 + x] = x % 10;
		}
		tilemap1.loadMapFromArray(tiles, 20, 20, "assets/images/tiles.png", 16, 16, null, 0, 0);
		tilemap1.scale.set(4, 4);
		
		tilemap1.y = 300;
		
		
		group1.add(sprite1);
		group1.add(sprite2);
		group1.add(sprite3);
		group1.add(tilemap1);
		
		
		group2.add(cameraBorder);
		group2.add(hint);
		group2.add(info);
		
		
		group1.forEach(function (obj: FlxBasic) 
		{
			obj.cameras = [ gameCamera ];
		});
		group2.forEach(function (obj: FlxBasic)
		{
			obj.cameras = [ uiCamera ];
		});
		
		
		//group1.cameras = [ gameCamera ];
		//group2.cameras = [ uiCamera ];
		
		//gameCamera.scroll.y = 50;
		//gameCamera.zoom = 0.7;
		
		gameCamera.bgColor = 0xff666666;
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		
		//gameCamera.alpha = 1;
		//uiCamera.alpha = 0.5;
		
		add(group2);
		add(group1);
		
		
		//FlxG.camera = gameCamera;
		//FlxG.cameras.reset(gameCamera);
		//FlxG.cameras.add(uiCamera);
		FlxG.cameras.reset(uiCamera);
		FlxG.cameras.add(gameCamera);
		//FlxCamera.defaultCameras = [ gameCamera ];
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.mouse.wheel != 0)
		{
			//trace("before: " + gameCamera.width);
			
			var newZoom = gameCamera.zoom + FlxG.mouse.wheel * 0.1;
			gameCamera.zoom = (newZoom < 0.1) ? 0.1 : newZoom;
				
			//gameCamera.width = Math.floor(FlxG.stage.width * gameCamera.zoom);
			//gameCamera.height = Math.floor(FlxG.stage.height * gameCamera.zoom);
				
			//trace("after: " + gameCamera.width);
				
			//gameCamera.width = FlxG.//Std.int(FlxG.stage.width);
			//gameCamera.height = //Std.int(FlxG.stage.height);
			
			//gameCamera.updateScroll();
		}
		
		var scrollSpeed = 2;
		if (FlxG.mouse.justPressedMiddle)
		{
			uiScrolling = true;
			uiScrollingPoint.set(FlxG.mouse.x - gameCamera.scroll.x * scrollSpeed, FlxG.mouse.y - gameCamera.scroll.y * scrollSpeed);
		}
		else if (FlxG.mouse.justReleasedMiddle)
		{
			uiScrolling = false;
		}
		else if (FlxG.mouse.pressedMiddle)
		{
			//if (uiScrolling)
			{
				gameCamera.scroll.set((FlxG.mouse.x - uiScrollingPoint.x) / scrollSpeed, (FlxG.mouse.y - uiScrollingPoint.y) / scrollSpeed);
				/*if (gameCamera.scroll.x < environment.map.x - environment.map.width)
					gameCamera.scroll.x = environment.map.x - environment.map.width;
				if (gameCamera.scroll.y < environment.map.y - environment.map.height)
					gameCamera.scroll.y = environment.map.y - environment.map.height;
				if (gameCamera.scroll.x > environment.map.x + environment.map.width * 2)
					gameCamera.scroll.x = environment.map.x + environment.map.width * 2;
				if (gameCamera.scroll.y > environment.map.y + environment.map.height * 2)
					gameCamera.scroll.y = environment.map.y + environment.map.height * 2;*/
			}
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			gameCamera.zoom = 1;
			gameCamera.scroll.set();
		}
		
		var speed = 400;
		if (FlxG.keys.pressed.UP)
		{
			gameCamera.scroll.y -= speed * elapsed;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			gameCamera.scroll.y += speed * elapsed;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			gameCamera.scroll.x -= speed * elapsed;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			gameCamera.scroll.x += speed * elapsed;
		}
		
		info.text = 'Camera zoom: ${gameCamera.zoom}\nCamera scroll: ${gameCamera.scroll}';
	}
}