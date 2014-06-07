package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    import mx.utils.ObjectUtil;

    public class Launcher extends FlxSprite{
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var m_world:b2World;

        public var baseSprite:FlxSprite;
        public var armSprite:FlxSprite;
        public var projectiles:Array;
        public var curProjectile:Projectile;

        public var throwAngle:Number = 90;
        public var rotateBack:Boolean = false;

        public var debugText:FlxText;

        public function Launcher(world:b2World) {
            m_world = world;
            projectiles = new Array();
            curProjectile = new Projectile(m_world);

            x = 20;
            y = 50;

            baseSprite = new FlxSprite(x, y);
            baseSprite.makeGraphic(20, 40, 0xffff0000);
            FlxG.state.add(baseSprite);

            armSprite = new FlxSprite(x, y);
            armSprite.makeGraphic(5, 15, 0xff00ff00);
            FlxG.state.add(armSprite);

            debugText = new FlxText(10,10,100,"");
            FlxG.state.add(debugText);
        }

        override public function update():void {
            timeFrame++;
            if(timeFrame % 50 == 0){
                timeSec++;
            }

            setPosition(new DHPoint(FlxG.mouse.x, y));

            if(FlxG.mouse.pressed()) {
                if(timeFrame % 20 == 0) {
                    throwAngle += (rotateBack ? -1 : 1) * 36;
                }
                if (throwAngle >= 180+90) {
                    rotateBack = true;
                } else if(throwAngle <= 90) {
                    rotateBack = false;
                }
            }

            armSprite.angle = 180 - throwAngle;

            for (var i:int = 0; i < projectiles.length; i++) {
                var projectile:Projectile = projectiles[i];
                projectile.update(new FlxPoint(x, y), throwAngle);

                if (projectile.inactive) {
                    projectiles.splice(projectiles.indexOf(projectile), 1);
                }
            }
            curProjectile.update(new FlxPoint(x, y), throwAngle);

            if (FlxG.mouse.justReleased()) {
                launchProjectile();
            }
        }

        public function setPosition(pos:DHPoint):void {
            if (pos.x > 0 && pos.x < (FlxG.width-50) / FlxG.camera.zoom) {
                x = pos.x;
                y = pos.y;

                baseSprite.x = x;
                baseSprite.y = y;

                armSprite.x = x;
                armSprite.y = y;
            }
        }

        public function launchProjectile():void {
            curProjectile.launch(throwAngle);
            projectiles.push(curProjectile);
            curProjectile = new Projectile(m_world);
        }

        public function testTargetCollide(tar:GroundTarget, _callback:Function):void {
            for (var j:Number = 0; j < projectiles.length; j++) {
                var proj:FlxSprite = projectiles[j].spr;
                FlxG.overlap(tar, proj, _callback);
                FlxG.overlap(tar, proj, targetCollide);
            }
        }

        public function targetCollide(tar:GroundTarget, p:FlxSprite):void {
            var proj:Projectile = getProjectileFromSprite(p);
            if (proj) {
                proj.destroy();
            }
        }

        public function getProjectileFromSprite(spr:FlxSprite):Projectile {
            for(var i:int = 0; i < projectiles.length; i++) {
                var p:Projectile = projectiles[i];
                if (p.spr == spr) {
                    return p;
                }
            }
            return null;
        }
    }
}
