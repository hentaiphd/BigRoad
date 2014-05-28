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
        public var traits:Array = ["Ichabod is a planet full of languages. Everyone speaks everything and they get along quite well.", "Nerkle is a zoo of a place. Not one creature looks alike. All the babies always look different and it's quite wonderful.", "Bloogs is a lonely place, full of sea creatures that can never swim. They are too light, and always float just above the water, no matter how hard they try to dive.", "Klotz is harsh and full of sharp sticks. They don't care, they'll poke anyone. Be careful!"];
        public var trait_status:Array = ["The stock person is very nice to you, and tips you well!\nYou're able to send your kid 200 PSD.", "The stock person is a little scatterbrained, but well meaning. She tips you well!\nYou're able to send your kid 200 PSD.", "There is no one to meet you at the stock station. You leave the supplies without getting paid.\nYou're able to send your kid 50 PSD.", "The stock person rushes you in and out, and leaves no tip.\nYou're able to send your kid 100 PSD."];
        public var current_trait:String;
        public var current_status:String;

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

            current_trait = traits[rand];
            current_status = trait_status[rand];

            if(scale > 1){
                this.scale.x = 2;
                this.scale.y = 2;
            } else {
                this.scale.x = 1;
                this.scale.y = 1;
            }
        }

        override public function update():void{
            super.update();
            timeFrame++;

            if(FlxG.keys.LEFT){
                this.x--;
            } else if(FlxG.keys.RIGHT){
                this.x++;
            }

            if(_moving){
                if(timeFrame%1 == 0){
                    if(this.scale.x < 10){
                        this.scale.x += .01;
                    } else {
                        _moving = false;
                    }

                    if(this.scale.y < 10){
                        this.scale.y += .01;
                    }
                }
            }
        }

        public function resetPos(newx:int, newy:int):void{
            var rand:Number = Math.random()*4;
            current_trait = traits[rand];
            current_status = trait_status[rand];

            this.scale.x = 1;
            this.scale.y = 1;

            this.x = newx;
            this.y = newy;

            if(rand < 1){
                loadGraphic(ImgPlanet1,false,false,40,40);
            } else if(rand < 2){
                loadGraphic(ImgPlanet2,false,false,40,40);
            } else if(rand < 3){
                loadGraphic(ImgPlanet3,false,false,40,40);
            } else if(rand < 4){
                loadGraphic(ImgPlanet4,false,false,40,40);
            }
        }
    }
}