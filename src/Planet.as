package
{
    import org.flixel.*;

    public class Planet extends FlxSprite{
        [Embed(source="../assets/planet1.png")] private var ImgPlanet1:Class;
        [Embed(source="../assets/planet2.png")] private var ImgPlanet2:Class;
        [Embed(source="../assets/planet3.png")] private var ImgPlanet3:Class;
        [Embed(source="../assets/planet4.png")] private var ImgPlanet4:Class;

        public var _moving:Boolean = true;
        public var timeFrame:Number = 0;
        public var earn:Boolean = true;
        public var current_trait:String;
        public var current_status:String;
        public var speed:Number = 5;
        public var _radius:Number;

        public function Planet(x:int,y:int,scale:int):void{
            super(x,y);
            var rand:Number = Math.floor(Math.random()*4);
            if(rand < 1){
                loadGraphic(ImgPlanet1,false,false,40,40);
            } else if(rand < 2){
                loadGraphic(ImgPlanet2,false,false,40,40);
            } else if(rand < 3){
                loadGraphic(ImgPlanet3,false,false,40,40);
            } else if(rand < 4){
                loadGraphic(ImgPlanet4,false,false,40,40);
            }

            _radius = this.width;
        }

        override public function update():void{
            super.update();
            timeFrame++;
        }
    }
}
