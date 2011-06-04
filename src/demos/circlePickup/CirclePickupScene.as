package demos.circlePickup
{
    import com.pblabs.core.PBGameObject;
    import com.pblabs.core.PBGroup;
    import com.pblabs.core.PBSet;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.geom.Point;
    import demos.SimplestDemoGameObject;
    
    /**
     * Demo which shows some very simple gameplay - move the mouse to pick
     * up objects in the game world. It demonstrates adding your own manager
     * to the game and how to use PBSet to keep track of active game objects.
     */
    public class CirclePickupScene extends PBGroup
    {
        /**
         * Set for tracking active gems. Gems are the circles that we can pick
         * up. Remember, a set only holds references to living objects. When
         * an object is destroy()ed, it is removed from any sets that reference
         * it. So it's a great way to track what gems are still alive. 
         */
        public var gemSet:PBSet;
        
        /**
         * This manager keeps track of the active circles, and is responsible
         * for destroy()ing them then we pick them up (by getting close). See
         * the comments in the GemManager for more information on managers in
         * PBE. 
         */
        public var gemManager:GemManager = new GemManager();
        
        /**
         * Get a reference to the stage via dependency injection.
         */
        [Inject]
        public var stage:Stage;
        
        public override function initialize():void
        {
            // Always let the parent class initialize().
            super.initialize();
            
            // Set up the PBSet for the gems.
            gemSet = new PBSet();
            gemSet.owningGroup = this;
            gemSet.initialize();
            
            // Tell the gem manager what set of objects to consider for 
            // picking up.
            gemManager.gemSet = gemSet;

            // Make the guy that follows the mouse pick stuff up.
            gemManager.pickerUpper = makeMouseFollower();
            
            // Make the gems.
            for(var i:int=0; i<20; i++)
                makeGem(new Point(stage.stageWidth * Math.random(), stage.stageHeight * Math.random()));
            
            // And, run a little bit of our own logic every frame.
            stage.addEventListener(Event.ENTER_FRAME, onFrame);
        }
        
        /**
         * This method is called when the scene is unloaded by PBEDemos (ie
         * when the current demo is switched). 
         */
        public override function destroy():void
        {
            // Only thing to clean up is the event listener. All the game
            // objects are owned by this group (remember, we subclass PBGroup)
            // so they will be cleaned up by the parent class logic.
            stage.removeEventListener(Event.ENTER_FRAME, onFrame);

            // Always pass control to the parent class.
            super.destroy();
        }
        
        /**
         * Let the gem pick up manager process every frame.
         */
        protected function onFrame(e:Event):void
        {
            gemManager.process();
        }
        
        /**
         * We have a method for each object type. This one is for making mouse
         * followers, game objects that follow the mouse around. We explain this
         * in detail in the MouseFollowerScene, it is a copy of the code there.
         */
        public function makeMouseFollower():SimplestDemoGameObject
        {
            var go:SimplestDemoGameObject = new SimplestDemoGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            const mfc:SimplestMouseFollowComponent = new SimplestMouseFollowComponent();
            mfc.targetProperty = "@spatial.position";
            go.addComponent(mfc, "mouse");
            
            go.initialize();
            
            return go;
        }
        
        /**
         * Create a gem at a given point. Gems are identical to the game
         * object we created in the BindingDemoScene. The only difference
         * is that we set the position based on the pos parameter, and
         * we also add them to the gems PBSet.
         */
        public function makeGem(pos:Point):SimplestDemoGameObject
        {
            // Create the mouse follower.
            var go:SimplestDemoGameObject = new SimplestDemoGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            go.spatial.position = pos.clone();
            
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            go.initialize(); 
            
            // Add it to the set of gems so we can easily keep track of it. The
            // gem set will keep a reference to it as long as it is alive, ie, 
            // destroy() has not been called.
            gemSet.add(go);
            
            return go;
        }
    }
}