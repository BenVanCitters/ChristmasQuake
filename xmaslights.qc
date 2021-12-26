entity lightsController;

float lightState;
float lastLightStateStart;
void() updateLightState=
{
	lightState = lightState +1;
	if(lightState > 8)
	{
		lightState = 0;
	}
}

void() lightsControllerThink =
{
	if(lightState == lastLightStateStart )
	{
		updateLightState();
		updateLightState();
	}
	lastLightStateStart = lightState;
	lightsController.think = lightsControllerThink;
	lightsController.nextthink = time + .6;
	
	//bprint("start light state: ");
	//bprint(ftos(lightState));
	//bprint("\n");	
	local entity itemx;
	itemx = find(world, isLight, "yes");
	while ((itemx != world))
	{
		//if we found an item
		if((itemx.flags & FL_ITEM) == FL_ITEM)
		{
			//entity.effects
			//00 (false) - off
			//01 (EF_BRIGHTFIELD) - one time whitish flash
			//02 (swim EF_MUZZLEFLASH)~lightning/missile launch , shooting, flash
			//04 (EF_BRIGHTLIGHT) bright white light
			//08 (EF_DIMLIGHT fl client) ~laser, vore missile, golden flicker
			//16 (inwater) - quad damage, blue/purplish flickery glow
			//32 (Monster) - IT_INVULNERABILITY flickering red
			//64 (godmode) - hellknight missile, grendae = harsh flicking yellow light
			itemx.effects = 0;
			//only change styles on existing items
			if(itemx.nextthink < time)
			{
				if(lightState == 0)
				{itemx.effects = 32;}//red
				else if(lightState == 3)
				{itemx.effects = 8;}//white
				else if(lightState == 6)
				{itemx.effects = 16;}//blue
			}
			
			updateLightState();
			//change light state
			
		}
		itemx = find(itemx,  isLight, "yes");
	}
	//updateLightState();
	
}


//creates gametype entity
void() spawnController =
{
	//bprint("spawning xmas controller!\n");	
	lightsController = spawn();
	lightsController.classname = "lightsController";
	lightsController.think = lightsControllerThink;
	lightsController.nextthink = time + 1;
}

//wrapper function - to make sure only one per game is created
//maybe even enforce game start requirements
void() spawnXMasController =
{
	//bprint("trying spawnController....\n");
	//only create hulk mode if it doesn't already exist
	local entity lightsCtrlr = find (world, classname, "lightsController");
	//eprint(lightsCtrlr);
	//eprint(lightsController);
	if(lightsCtrlr || lightsController)
	{
		//bprint("lightsCtrlr exists exiting...");
		return;
	}
	spawnController();
}