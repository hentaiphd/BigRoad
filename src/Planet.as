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
        public var earning:Array = [true,true,false,true,false,true,true,true,true,false,false,false,false]
        public var traits:Array = ["Ikabod is a planet full of languages. Everyone speaks everything and they get along quite well.",
        "Nerkel is a zoo of a place. Not one creature looks alike. All the babies always look different and it's quite wonderful.",
        "Bloofs is full of sea creatures that can't swim. They are too light, and float just above the water, no matter how hard they try.",
        "Klots is harsh and full of sharp sticks. They don't care, they'll poke anyone. Be careful!",
        "West Bees is a planet with a single island, full of colossal creatures shaped like eggs. They bite.",
        "Wockel is a pocket sized planet. It's full of real chatterboxes shaped like people.",
        "Ploo is a little planet full of lovely fuzzy people that love to hug.",
        "Pleep is a huge planet full of sprinters. Everyone's always in a rush, scrambling to train for the next big race.",
        "Biv is where musicians like to live. The entire place is a band and no one ever stops playing.",
        "Clandall is a planet full of sleepwalkers. I wonder when they'll wake up?",
        "Topp is a planet for packing. Everything in the store is wrapped up and sealed here.",
        "Effel is a planet with huge morphing mountains. It's dangerous. Don't get crushed!",
        "Spackle is the planet where Yees live. Yees are shy, and flee at the drop of a pin."];
        public var trait_status:Array = ["The stock person is very nice to you, and tips you well!",
        "The stock person is a little scatterbrained, but well meaning. She tips you well!",
        "There is no one to meet you at the stock station. You leave the supplies without getting paid.",
        "The stock person rushes you in and out, and leaves no tip.",
        "There is no stock person. You get chased away by the egg-shaped creatures.",
        "The stock person talks your ear off, but you like him because his tips are good.",
        "The stock person gives you cookies and milk, and sends you off with a hug and a tip!",
        "The stock person rushes you in and out, and leaves no tip.",
        "The stock person plays you a little tune and hands you a tip.",
        "The stock person is asleep. You leave without getting paid.",
        "There is no stock person. Everything's done by machines.",
        "There is no stock person. The mountains are too dangerous.",
        "There is no stock person. The Yees are too afraid."];
        public var current_trait:String;
        public var current_status:String;
        public var speed:Number = 5;

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
            earn = earning[rand];

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

            if(_moving){
                if(FlxG.keys.LEFT){
                    this.x -= speed;
                } else if(FlxG.keys.RIGHT){
                    this.x += speed;
                }

                if(timeFrame%1 == 0){
                    if(this.scale.x < 10){
                        this.scale.x += .03;
                    } else {
                        _moving = false;
                    }

                    if(this.scale.y < 10){
                        this.scale.y += .03;
                    }
                }
            }
        }

        public function resetPos(newx:Number, newy:Number):void{
            var rand:Number = Math.floor(Math.random()*traits.length);
            current_trait = traits[rand];
            current_status = trait_status[rand];
            earn = earning[rand];

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
