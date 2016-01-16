package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import entities.Player;
import entities.Laser;
import entities.powerups.Carrot;
import com.haxepunk.Sfx;

class Bear extends Entity
{
	private var sprite:Spritemap;
	private var hp:Int;
	private var player:Entity;
	public var roar:Sfx;

	public function new() {
		super(HXP.width, (HXP.height * Math.random() - 60) );
		sprite = new Spritemap("graphics/bear.png", 96, 60);
		sprite.add("walk", [1, 2], 6);
		sprite.play("walk");
		graphic = sprite;

		setHitbox(96, 60);

		hp = 3;
		roar = new Sfx("audio/bear.ogg");

		type = "bear";
	}

	public override function added() {
		player = HXP.scene.entitiesForType("player").first();
			
		KH.play(roar);
	}

	public override function update() {
		if (hp == 3) {
			moveTowards(-130, Math.random() * HXP.height, 80 * HXP.elapsed);
		} else {
			moveTowards(player.x, player.y, 150 * HXP.elapsed);
		}

		if (collide("player", x, y) != null) {
			KH.stopAllSounds();
			HXP.scene = new scenes.GameOverScene();
		}

		var laser = collide("laser", x, y);

		if (laser != null) {
			hp--;
			HXP.scene.remove(laser);

			if (hp == 0) {
				HXP.scene.remove(this);
			}
		}

		if (x <= 0 - width) {
			var carrot = new Carrot(HXP.halfWidth - 16, HXP.halfHeight -16);
			HXP.scene.add(carrot);

			HXP.scene.remove(this);
		}

		super.update();

	}
}