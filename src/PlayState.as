package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    import flash.display.Sprite;
    import flash.utils.setTimeout;

    public class PlayState extends FlxState{
        [Embed(source="../assets/space1.png")] private var ImgBg:Class;
        [Embed(source="../assets/gametruck.png")] private var ImgTruck:Class;
        [Embed(source="../assets/planet_close.png")] private var ImgPlanetClose:Class;
        [Embed(source="../assets/planet.png")] private var ImgPlanet:Class;
        [Embed(source="../assets/instructions.png")] private var ImgHelp:Class;
        [Embed(source="../assets/spacedad.mp3")] private var SndBGM:Class;

        public var _bg:FlxSprite;
        public var debugText:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var m_world:b2World;
        public static var m_physScale:Number = 30
        public var targets:Array;

        public var launcher:Launcher = null;
        public var truckSprite:FlxSprite;
        public var planetCloseSprite:FlxSprite;
        public var planet:FlxSprite;

        public var startTime:Number = -1;

        public var click_counter:Number = 0;
        public var planets_visited:Number = 0;
        public var plushies_delivered:Number = 0;

        public var fadein:Boolean = true;
        public var animLock:Boolean = false;
        public var _active:Boolean = true;

        public var smoke:FlxSprite;
        public var help_text:FlxSprite;
        public var starting_mouse_x:Number;

        public function PlayState(planet_count:Number = 0, plushie_count:Number = 0):void{
            planet_count++;
            planets_visited = planet_count;
            plushies_delivered = plushie_count;
        }

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            truckSprite = new FloatySprite(100, 20);
            truckSprite.loadGraphic(ImgTruck, true, true, 100, 64, true);
            truckSprite.addAnimation("idle", [0], 1, false);
            truckSprite.addAnimation("open", [1], 1, false);
            truckSprite.addAnimation("boost", [2, 3, 4], 12, true);
            add(truckSprite);
            truckSprite.play("open");

            planetCloseSprite = new FlxSprite(0, 80);
            planetCloseSprite.loadGraphic(ImgPlanetClose, true, true, 320, 160, true);
            planetCloseSprite.addAnimation("1", [0], 1, false);
            planetCloseSprite.addAnimation("2", [1], 1, false);
            planetCloseSprite.addAnimation("3", [2], 1, false);
            planetCloseSprite.play(planets_visited + "");
            add(planetCloseSprite);
            planetCloseSprite.alpha = 0;

            planet = new FlxSprite(210,65);
            planet.loadGraphic(ImgPlanet,false,false,64,64);
            add(planet);
            planet.scale.x = .5;
            planet.scale.y = .5;

            debugText = new FlxText(10,10,100,"");
            add(debugText);

            targets = new Array();
            for (var i:int = 0; i < 3; i++) {
                addNewTarget();
            }
            for(i = 0; i < targets.length; i++){
                targets[i].alpha = 0;
            }

            setupWorld();

            launcher = new Launcher(m_world);

            if (planets_visited == 1) {
                smoke = new FlxSprite(0, 0);
                smoke.makeGraphic(320, 240, 0xaa000000);
                add(smoke);

                help_text = new FlxSprite(20,100);
                help_text.loadGraphic(ImgHelp,false,false,228,48);
                add(help_text);
            } else {
                startTime = new Date().valueOf();
            }

            starting_mouse_x = FlxG.mouse.x;

            if(FlxG.music == null){
                FlxG.playMusic(SndBGM);
            } else {
                FlxG.music.resume();
                if(!FlxG.music.active){
                    FlxG.playMusic(SndBGM);
                }
            }
        }

        override public function update():void{
            super.update();

            if (planets_visited == 1) {
                if (FlxG.mouse.x != starting_mouse_x) {
                    remove(smoke);
                    remove(help_text);
                    if (startTime == -1) {
                        startTime = new Date().valueOf();
                    }
                }
            }

            if(fadein){
                launcher.fadeIn();
                planetCloseSprite.alpha += .01;
                for(i = 0; i < targets.length; i++){
                    targets[i].alpha += .01;
                }
                if (planetCloseSprite.alpha == 1) {
                    fadein = false;
                }
            }

            var cur_time:Number = new Date().valueOf();
            if (startTime != -1) {
                if(cur_time - startTime > 15000){
                    _active = false;
                    planetCloseSprite.alpha -= .01;
                    launcher._active = false;
                    launcher.fadeOut();
                    for (i = 0; i < targets.length; i++) {
                        targets[i].alpha -= .01;
                    }
                    truckSprite.play("idle");
                }
                if(cur_time - startTime > 17000){
                    FlxG.switchState(new DriveState(planets_visited,plushies_delivered));
                }
            }

            if(FlxG.mouse.justPressed()){
                click_counter++;
            }

            launcher.update();

            m_world.Step(1.0/30.0, 10, 10);
            //m_world.DrawDebugData();

            timeFrame++;
            if(timeFrame % 50 == 0){
                timeSec++;
            }

            for (var i:Number = 0; i < targets.length; i++) {
                var tar:GroundTarget = targets[i];
                if (tar._active) {
                    launcher.testTargetCollide(tar, projectileTargetCollision);
                } else {
                    targets.splice(targets.indexOf(tar), 1);
                }
            }
        }

        public function projectileTargetCollision(tar:GroundTarget,proj:FlxSprite):void{
            if (tar._active) {
                tar.makeInactive();
                setTimeout(addNewTarget, Math.random()*3000);
                plushies_delivered++;
            }
        }

        public function addNewTarget():void {
            if(FlxG.state == this && _active) {
                var t:GroundTarget = new GroundTarget(
                    new DHPoint(Math.random()*((FlxG.width-50)/FlxG.camera.zoom),
                    177),planets_visited);
                add(t);
                targets.push(t);
            }
        }

        private function setupWorld():void{
            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            m_world = new b2World(gravity,true);

            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            FlxG.stage.addChild(dbgSprite);
            dbgDraw.SetSprite(dbgSprite);
            dbgDraw.SetDrawScale(30.0);
            dbgDraw.SetFillAlpha(0.3);
            dbgDraw.SetLineThickness(1.0);
            dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            m_world.SetDebugDraw(dbgDraw);

            // Create border of boxes
            var wall:b2PolygonShape= new b2PolygonShape();
            var wallBd:b2BodyDef = new b2BodyDef();
            var wallB:b2Body;

            // Left
            wallBd.position.Set( -95 / m_physScale, 480 / m_physScale / 2);
            wall.SetAsBox(100/m_physScale, 480/m_physScale/2);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
            // Right
            wallBd.position.Set((640 + 95) / m_physScale, 480 / m_physScale / 2);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
            // Top
            wallBd.position.Set(640 / m_physScale / 2, -95 / m_physScale);
            wall.SetAsBox(680/m_physScale/2, 100/m_physScale);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
            // Bottom
            wallBd.position.Set(640 / m_physScale / 2, (FlxG.height + 70) / m_physScale);
            wallB = m_world.CreateBody(wallBd);
            wallB.CreateFixture2(wall);
        }
    }
}
