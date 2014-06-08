package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    import flash.utils.setTimeout;

    public class Launcher extends FlxSprite{
        [Embed(source="../assets/dad.png")] private var ImgDad:Class;
        [Embed(source="../assets/dad_arm.png")] private var ImgDadArm:Class;

        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var m_world:b2World;

        public var baseSprite:FlxSprite;
        public var armSprite:FlxSprite;
        public var projectiles:Array;
        public var curProjectile:Projectile;

        public var throwAngle:Number;
        public var rotateBack:Boolean = false;
        public var launchLock:Boolean = false;
        public var armForward:Boolean = false;
        public var armDrawAngle:Number;
        public var thisThrowAngle:Number;
        public var throwStartAngle:Number;
        public var throwAngleArc:Number;

        public var debugText:FlxText;

        public function Launcher(world:b2World) {
            m_world = world;
            projectiles = new Array();
            curProjectile = new Projectile(m_world);

            x = 20;
            y = 50;

            throwStartAngle = throwAngle = 135;
            throwAngleArc = 90;

            baseSprite = new FlxSprite(x, y);
            baseSprite.loadGraphic(ImgDad, true, true, 48, 48, true);
            baseSprite.addAnimation("rest", [1], 1, false);
            baseSprite.addAnimation("throw", [0], 1, false);
            baseSprite.play("rest")
            FlxG.state.add(baseSprite);

            armSprite = new FlxSprite(x, y);
            armSprite.loadGraphic(ImgDadArm, true, true, 8, 64, true);
            armSprite.visible = false;
            FlxG.state.add(armSprite);

            debugText = new FlxText(100,100,100,"");
            FlxG.state.add(debugText);

            baseSprite.alpha = 0;
            armSprite.alpha = 0;
        }

        override public function update():void {
            timeFrame++;
            if(timeFrame % 50 == 0){
                timeSec++;
            }

            setPosition(new DHPoint(FlxG.mouse.x, y));

            if (armForward) {
                if (armDrawAngle < thisThrowAngle) {
                    if (timeFrame % 2 == 0) {
                        armDrawAngle += 30;
                    }
                } else {
                    if (!launchLock) {
                        launchProjectile(armDrawAngle);
                        launchLock = true;
                    }
                    setTimeout(resetArm, 500);
                }
            } else {
                if(FlxG.mouse.pressed()) {
                    baseSprite.play("throw");
                    armSprite.visible = true;
                    if(timeFrame % 5 == 0) {
                        throwAngle += (rotateBack ? -1 : 1) * 25;
                    }
                    if (throwAngle >= throwStartAngle + throwAngleArc) {
                        rotateBack = true;
                    } else if(throwAngle <= throwStartAngle) {
                        rotateBack = false;
                    }
                    armDrawAngle = throwAngle;
                } else {
                    armDrawAngle = throwStartAngle;
                }
            }

            armSprite.x = baseSprite.x + 19;
            armSprite.y = baseSprite.y - 20;
            armSprite.angle = 180 - armDrawAngle;
            curProjectile.update(new FlxPoint(x+19, y), armDrawAngle);

            for (var i:int = 0; i < projectiles.length; i++) {
                var projectile:Projectile = projectiles[i];
                projectile.update();

                if (projectile.inactive) {
                    projectiles.splice(projectiles.indexOf(projectile), 1);
                }
            }

            if (FlxG.mouse.justReleased()) {
                armForward = true;
                thisThrowAngle = throwAngle + 180;
                armDrawAngle = throwAngle;
            }

            if (FlxG.mouse.justPressed()) {
                throwAngle = throwStartAngle;
            }
        }

        public function resetArm():void {
            armForward = false;
            launchLock = false;
            armDrawAngle = throwAngle;
            try {
                baseSprite.play("rest");
            } catch (err:Error) {
            }
            armSprite.visible = false;
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

        public function fadeOut():void{
            baseSprite.alpha -= .01;
            armSprite.alpha -= .01;
        }

        public function fadeIn():void{
            baseSprite.alpha += .01;
            armSprite.alpha += .01;
        }

        public function launchProjectile(angle:Number):void {
            curProjectile.launch(angle);
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
