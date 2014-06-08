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
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;
        [Embed(source="../assets/FORCEDSQUARE.ttf", fontFamily="FORCEDSQUARE", embedAsCFF="false")] public var FontHud:String;

        public var _bg:FlxSprite;
        public var debugText:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var m_world:b2World;
        public static var m_physScale:Number = 30
        public var targets:Array;

        public var launcher:Launcher = null;

        public var now:Date;
        public var startTime:Date;

        public var click_counter:Number = 0;
        public var planets_visited:Number = 0;
        public var plushies_delivered:Number = 0;

        public function PlayState(planet_count:Number = 0, plushie_count:Number = 0):void{
            planet_count++;
            planets_visited = planet_count;
            plushies_delivered = plushie_count;
        }

        override public function create():void{
            startTime = new Date();

            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            debugText = new FlxText(10,10,100,"");
            add(debugText);

            targets = new Array();
            for (var i:int = 0; i < 3; i++) {
                addNewTarget();
            }

            setupWorld();

            launcher = new Launcher(m_world);
        }

        override public function update():void{
            super.update();
            if(new Date().valueOf() - startTime.valueOf() > 15000){
                FlxG.switchState(new DriveState(planets_visited,plushies_delivered));
            }

            if(FlxG.mouse.justPressed()){
                click_counter++;
            }

            debugText.text = "Plushies delivered: " + plushies_delivered.toString() + "\nPlanets visited: " + planets_visited.toString();

            launcher.update();

            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();

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
            if(FlxG.state == this) {
                var t:GroundTarget = new GroundTarget(
                    new DHPoint(Math.random()*((FlxG.width-50)/FlxG.camera.zoom),
                    200));
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
