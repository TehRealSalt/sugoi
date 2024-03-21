/////////////////////////////
//NOTES THAT CAN BE IGNORED//
/////////////////////////////
// YORB: 25x25 pix, anchored bottom left
// HRTPPLAY: 21x32 pix, anchored center, 1 pix to the left
// HRTPSHOT: 10x16 pix, anchored center
// HRTPSLID: 48x31 pix, anchored center. Of note is that part of the vertical height is taken up by particles, 6 pixels to be exact.
// HRTP Swinging animation: 53x42 pix in all. 22 pix left of plrpos, 31 pix to the right.
// Player collision box will probably be 44 wide instead. 22 pix to each side.
/////////////
//NOTES END//
/////////////

addHook("PreThinkFrame", do
	// Sal: Just store the spin button on a different button,
	// so we can exclude all spin abilities, even custom ones.

	if (mapheaderinfo[gamemap].sugoihrtp)
		for player in players.iterate do
			if (player.hrtpinit)
				player.hrtp.use = (player.cmd.buttons & BT_SPIN);
				player.cmd.buttons = $1 & ~BT_SPIN;
			end
		end
	end
end)

addHook("ThinkFrame", do
	if (mapheaderinfo[gamemap].sugoihrtp) // Salt: Switching these two lines around,
		for player in players.iterate // so it avoids iterating players every tic on all maps
			if (player.bot) continue end // Salt: doesn't cause any foreseeable problems, but Just In Case[tm]
			if (player.exiting) continue end // Sal: also just don't run any of the code in this instance anymore either.

			if (player.hrtpinit == nil)

				//print("Please use a green resolution higher then 640x400!")

				player.hrtp = {} // Sal: Made this a table!

				player.hrtp.gravity = 1
				player.hrtp.gravitydelay = 0

				player.hrtp.shotx = {}
				player.hrtp.shoty = {}

				for i=1, 50 do
					player.hrtp.shotx[i] = 999
					player.hrtp.shoty[i] = 999
				end

				player.hrtp.lvl = {}          -- create the matrix
				for i=1,180 do
					player.hrtp.lvl[i] = {}     -- create a new row
					for j=1,4 do
						player.hrtp.lvl[i][j] = 999
					end
				end

				player.hrtp.timer = 1000
				player.hrtp.harryup = 0
				player.hrtp.bulletsnowdelay = 0

				player.hrtp.bullet = {}          -- create the matrix
				for i=1,100 do
					player.hrtp.bullet[i] = {}     -- create a new row
					for j=1,5 do
						player.hrtp.bullet[i][j] = 999 -- X, Y , MOMX, MOMY, BulletType
					end
				end

				player.hrtp.item = {}
				for i=1,100
					player.hrtp.item[i] = {}
					for o=1,3
						player.hrtp.item[i][o] = 999 -- X,Y,Phase
					end
				end

				player.hrtp.points = 0
				player.hrtp.gainlife = 1
				player.hrtp.itemcombo = 1
				player.hrtp.overtime = 0

				player.hrtp.level = 1
				player.hrtp.pregame = 0



				player.hrtp.bossx = 999
				player.hrtp.bossy = 999
				player.hrtp.bossattack = 0
				player.hrtp.bosshealth = 12
				player.hrtp.bosswait = 0
				player.hrtp.bosscycle = 0
				player.hrtp.bossgonnaattackx = 999
				player.hrtp.bossgonnaattacky = 999
				//player.hrtp.timer = 5000
				player.hrtp.bossinvinc = 0


			//player.hrtp.bossx = 999
			//player.hrtp.bossy = 999
			//player.hrtp.timer = remove


				player.hrtp.pos = 300
				player.hrtp.invincibility = 0
				player.hrtp.dead = 0
				player.hrtp.sparkl = 999
				player.hrtp.sparkr = 999



				player.hrtp.orbposx = 600
				player.hrtp.orbposy = 300
				player.hrtp.orbmomx = 0
				player.hrtp.orbmomy = 0
				player.hrtp.orbwarpdelay = 0



				player.hrtp.orbstart = 0
				player.hrtp.startdelay = 0



				player.hrtp.sliding = 0



				player.hrtp.shotdelay = 0



				player.hrtp.swing = 0
				player.hrtp.swingtimer = 0

				player.hrtp.pause = 0

				player.hrtp.lives = 4

				player.hrtp.givepoints = 1
				player.hrtp.use = 0

				player.hrtpinit = 1
			end

			if player.hrtp.SUGOISpecialStage == nil
				player.hrtp.SUGOISpecialStage = 1 //Change this to 0 if it's not going to be a special stage. If it is, check line 1087.
			end

			// player setup
			player.pflags = $1|PF_FORCESTRAFE|PF_JUMPSTASIS
			if player.hrtp.givepoints == 1
				P_AddPlayerScore(player, player.hrtp.points)
				player.hrtp.givepoints = 0
			end

			// Level setup
			if player.hrtp.pregame == 0
				if player.hrtp.level == 1
					player.lvld = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,2,0,0,0,0,0,0,0,0,2,0,0,0,0,0,
								   0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,
								   0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,
								   0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

					player.lvldsub = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,
									  0,0,0,0,0,4,4,4,0,0,0,0,4,4,4,0,0,0,0,0,
									  0,0,0,0,0,4,4,4,4,4,4,4,4,4,4,0,0,0,0,0,
									  0,0,0,0,0,4,4,4,4,4,4,4,4,4,4,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
				end

				if player.hrtp.level == 2
					player.lvld = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,1,0,1,0,1,0,0,0,3,3,0,0,0,1,0,1,0,1,0,
								   0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,
								   1,0,1,0,1,0,1,0,0,1,1,0,0,1,0,1,0,1,0,1,
								   0,1,0,1,0,1,0,0,1,1,1,1,0,0,1,0,1,0,1,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

					player.lvldsub = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,4,0,4,0,4,0,0,0,1,1,0,0,0,4,0,4,0,4,0,
									  0,4,0,4,0,4,0,0,0,0,0,0,0,0,4,0,4,0,4,0,
									  4,0,4,0,4,0,4,0,0,4,4,0,0,4,0,4,0,4,0,4,
									  0,4,0,4,0,4,0,0,4,4,4,4,0,0,4,0,4,0,4,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
				end

				if player.hrtp.level == 3
					player.lvld = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
								   0,0,0,0,0,1,0,1,0,3,3,0,1,0,0,0,1,0,1,0,
								   1,0,2,0,1,0,1,0,1,0,0,1,0,1,0,1,0,0,0,1,
								   0,1,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,
								   0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,0,0,1,0,0,
								   0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,1,0,1,0,
								   0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

					player.lvldsub = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,
									  0,0,0,0,0,4,0,4,0,1,1,0,4,0,0,0,4,0,4,0,
									  4,0,1,0,4,0,4,0,4,0,0,4,0,4,0,4,0,0,0,4,
									  0,4,0,4,0,0,0,0,0,4,4,0,0,0,4,0,0,0,0,0,
									  0,0,4,0,0,0,4,0,0,0,0,4,0,4,0,0,0,4,0,0,
									  0,0,0,0,0,4,0,4,0,0,0,0,4,0,0,0,4,0,4,0,
									  0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,4,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
				end

				if player.hrtp.level == 4
					player.lvld = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,
								   0,0,1,0,1,1,0,1,1,0,0,1,1,0,1,1,0,1,0,0,
								   0,1,1,1,0,0,1,1,0,3,3,0,1,1,0,0,1,1,1,0,
								   0,0,1,0,3,0,0,1,1,0,0,1,1,0,0,3,0,1,0,0,
								   0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

					player.lvldsub = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0,0,0,
									  0,0,4,0,4,4,0,4,4,0,0,4,4,0,4,4,0,4,0,0,
									  0,4,4,4,0,0,4,4,0,2,2,0,4,4,0,0,4,4,4,0,
									  0,0,4,0,1,0,0,4,4,0,0,4,4,0,0,1,0,4,0,0,
									  0,0,0,0,0,0,0,0,4,4,4,4,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

				end

				if player.hrtp.level == 5
					player.lvld = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

					player.lvldsub = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
									  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

				end


				for i=1,180
					if i % 20 == 0
						player.hrtp.lvl[i][1] = 19 * 32
					else
						player.hrtp.lvl[i][1] = ((i % 20) - 1) * 32
					end

					if i % 20 == 0
						player.hrtp.lvl[i][2] = (((i/ 20) - 1) * 32) + 64
					else
						player.hrtp.lvl[i][2] = ((i / 20) * 32) + 64
					end
					player.hrtp.lvl[i][3] = player.lvld[i]
					player.hrtp.lvl[i][4] = player.lvldsub[i]
				end




				player.hrtp.pregame = 1
			end

			// Start the round already!
			if player.hrtp.orbstart == 0
				and ((player.cmd.buttons & BT_JUMP) or player.hrtp.level == 5)
				player.hrtp.orbmomx = -10
				player.hrtp.orbmomy = -14
				player.hrtp.orbstart = 1
			end

			if player.hrtp.startdelay > 1
				player.hrtp.startdelay = $1 - 1
			end


			// Death and stuff
			if player.hrtp.dead == 3
				if player.respawn > 0
					player.respawn = $1 - 1
				end
				if player.respawn == 0
					player.hrtp.dead = 2
					if player.hrtp.timer < 1000
						player.hrtp.timer = 1000
					end
					player.hrtp.harryup = 0
					for i=1,100
						player.hrtp.bullet[i][1] = 999
					end
					player.hrtp.lives = $1 - 1
					player.hrtp.overtime = 1
					if player.hrtp.lives == 0
						player.exiting = 3

						if player.hrtp.givepoints == 1
							P_AddPlayerScore(player, player.hrtp.points)
							player.hrtp.givepoints = 0
						end

						player.hrtp = nil
						player.hrtpinit = nil
						return
					end
				end
			end

			if player.hrtp.dead == 2
				for i=0,4
					if player.hrtp.sparkl > player.hrtp.pos - 100
						and player.hrtp.sparkl > 0
						player.hrtp.sparkl = $1 - 1
					end
					if player.hrtp.sparkr < player.hrtp.pos + 100
						and player.hrtp.sparkr < 636
						player.hrtp.sparkr = $1 + 1
					end

					if player.hrtp.sparkl == player.hrtp.pos - 100 or player.hrtp.sparkr == player.hrtp.pos + 100
						player.hrtp.dead = 1
						player.hrtp.pos = 320
					end
				end
			end

			if player.hrtp.dead == 1
				for i=0,4
					if player.hrtp.sparkl > player.hrtp.pos
						player.hrtp.sparkl = $1 - 1
					elseif player.hrtp.sparkl < player.hrtp.pos
						player.hrtp.sparkl = $1 + 1
					end
					if player.hrtp.sparkr > player.hrtp.pos
						player.hrtp.sparkr = $1 - 1
					elseif player.hrtp.sparkr < player.hrtp.pos
						player.hrtp.sparkr = $1 + 1
					end
				end

				if player.hrtp.sparkl == player.hrtp.pos and player.hrtp.sparkr == player.hrtp.pos
					player.hrtp.dead = 0
					player.hrtp.invincibility = 5*TICRATE
				end
			end

			// Pause starts here!!!!!
			if player.hrtp.dead == 0 or player.exiting != 0

				// Swinging handler
				if player.hrtp.swing > 0
					player.hrtp.swingtimer = $1 -1
					if player.hrtp.swingtimer == 0 and player.hrtp.swing == 1
						player.hrtp.swing = 2
						player.hrtp.swingtimer = 8
					elseif player.hrtp.swingtimer == 0 and player.hrtp.swing == 2
						player.hrtp.swing = 0
					end
				end

				// movement input
				if player.hrtp.sliding == 0
					and player.hrtp.swing == 0
					if player.cmd.sidemove > 0
						and player.hrtp.pos < 629
						player.hrtp.pos = $1 + 6
					elseif player.cmd.sidemove < 0
						and player.hrtp.pos > 10
						player.hrtp.pos = $1 - 6
					end
				end

				// Shooting Code
				if (player.cmd.buttons & BT_JUMP)
					and player.hrtp.shotdelay == 0
					and player.hrtp.sliding == 0
					and player.hrtp.swing == 0
					for k,v in ipairs(player.hrtp.shotx)
						if v == 999
							player.hrtp.shotx[k] = player.hrtp.pos
							player.hrtp.shoty[k] = 368
							player.hrtp.shotdelay = 1
							break
						end
					end
				end

				// sliding input
				if player.cmd.sidemove > 0
					and player.hrtp.use != 0
					and player.hrtp.sliding == 0
					and player.hrtp.swing == 0
					player.hrtp.sliding = 14
				elseif player.cmd.sidemove < 0
					and player.hrtp.use != 0
					and player.hrtp.sliding == 0
					player.hrtp.sliding = -14
				end

				// Swinging Input
				if player.hrtp.use != 0
					and player.cmd.sidemove == 0
					and player.hrtp.sliding == 0
					and player.hrtp.swing == 0
					player.hrtp.swingtimer = 8
					player.hrtp.swing = 1
				end


				// sliding handlers
				if player.hrtp.sliding > 0
					player.hrtp.pos = $1 + 8
					while player.hrtp.pos > 629
						player.hrtp.pos = $1 - 1
					end
					player.hrtp.sliding = $1 - 1
				end

				if player.hrtp.sliding < 0
					player.hrtp.pos = $1 - 8
					while player.hrtp.pos < 10
						player.hrtp.pos = $1 + 1
					end
					player.hrtp.sliding = $1 + 1
				end


				// cant just spam shots each frame
				if not (player.cmd.buttons & BT_JUMP)
					player.hrtp.shotdelay = 0
				end

				//EXTEND!
				if player.hrtp.points >= (player.hrtp.gainlife * 20000)
					player.hrtp.lives = $1 + 1
					player.hrtp.gainlife = $1 + 1
				end

				//Timer and HARRY UP
				if player.hrtp.orbstart == 1
					and player.hrtp.timer > 0
					player.hrtp.timer = $1 - 1
				end

				if player.hrtp.timer == 0
					if player.hrtp.harryup == 0
						player.hrtp.harryup = 3
					else
						player.hrtp.harryup = $1 + 1
					end
					player.hrtp.timer = 200
				end

				if player.hrtp.bulletsnowdelay > 0
					player.hrtp.bulletsnowdelay = $1 - 1
				end

				if player.hrtp.harryup > 0 and player.hrtp.bulletsnowdelay == 0
					for i=1, player.hrtp.harryup
						for i=1,100
							if player.hrtp.bullet[i][1] == 999
								player.hrtp.bullet[i][1] = P_RandomKey(641)
								player.hrtp.bullet[i][2] = 72
								player.hrtp.bullet[i][3] = P_RandomKey(17) - 8
								player.hrtp.bullet[i][4] = 5
								break
							end
						end
						if player.hrtp.harryup >= 3
							player.hrtp.bulletsnowdelay = 20
						end
						if player.hrtp.harryup >= 6
							player.hrtp.bulletsnowdelay = 10
						end
						if player.hrtp.harryup >= 9
							player.hrtp.bulletsnowdelay = 5
						end
					end
				end

				//IM INVINCIBILE!!!
				if player.hrtp.invincibility > 0
					player.hrtp.invincibility = $1 - 1
				end

				//Don't get shot, idiot!
				for i=1,100
					if player.hrtp.bullet[i][1] != 999
						if player.hrtp.invincibility == 0
							if player.hrtp.sliding == 0
								and player.hrtp.swing != 1
								if player.hrtp.bullet[i][2] > 368
									and player.hrtp.bullet[i][1] > player.hrtp.pos - 10 and player.hrtp.bullet[i][1] < player.hrtp.pos + 11
									player.hrtp.dead = 3
									player.hrtp.sparkl = player.hrtp.pos
									player.hrtp.sparkr = player.hrtp.pos
									player.respawn = 1*TICRATE
								end
							end
							if player.hrtp.sliding != 0
								and player.hrtp.bullet[i][2] > 375
								and player.hrtp.bullet[i][1] > player.hrtp.pos - 10 and player.hrtp.bullet[i][1] < player.hrtp.pos + 11
								player.hrtp.dead = 3
								player.hrtp.sparkl = player.hrtp.pos
								player.hrtp.sparkr = player.hrtp.pos
								player.respawn = 1*TICRATE
							end
							if player.hrtp.swing == 1
								and player.hrtp.bullet[i][2] > 368
								and player.hrtp.bullet[i][1] > player.hrtp.pos - 10 and player.hrtp.bullet[i][1] < player.hrtp.pos + 11
								player.hrtp.bullet[i][1] = 999
							end
						end
					end
				end

				// Ball crushing.

				if player.hrtp.orbposy > 368
					and player.hrtp.orbposx + 25 > player.hrtp.pos - 9 and player.hrtp.orbposx < player.hrtp.pos + 10
					and player.hrtp.swing == 0
					and player.hrtp.sliding == 0
					and player.hrtp.invincibility == 0
					player.hrtp.dead = 3
					player.hrtp.sparkl = player.hrtp.pos
					player.hrtp.sparkr = player.hrtp.pos
					player.respawn = 1*TICRATE
				end

				//Level related variables
				player.hrtp.tilesleft = 0

				if player.hrtp.orbwarpdelay > 0
					player.hrtp.orbwarpdelay = $1 - 1
				end

				// Level collisions loop
				for i=1, 180
					if player.hrtp.lvl[i][3] == 1
						// Tile Collision
						if player.hrtp.lvl[i][4] == 4
							if player.hrtp.orbposy < player.hrtp.lvl[i][2] + 56 and player.hrtp.orbposy > player.hrtp.lvl[i][2]
								if player.hrtp.orbposx > player.hrtp.lvl[i][1] - 24 and player.hrtp.orbposx < player.hrtp.lvl[i][1] + 32
									player.hrtp.lvl[i][4] = 3
								end
							end
						end
						// Tile Flipping
						if player.hrtp.lvl[i][4] == 3
							player.hrtp.lvl[i][4] = 2
						elseif player.hrtp.lvl[i][4] == 2
							player.r = P_RandomKey(8)
							if player.r == 0
								for o=1,100
									if player.hrtp.item[o][1] == 999
										player.hrtp.item[o][1] = player.hrtp.lvl[i][1] + 4
										player.hrtp.item[o][2] = player.hrtp.lvl[i][2] + 5
										player.hrtp.item[o][3] = 1
										break
									end
								end
							end
							player.hrtp.lvl[i][4] = 1
						elseif player.hrtp.lvl[i][4] == 1
							player.hrtp.lvl[i][4] = 0
						end
						// How many left to go?
						if player.hrtp.lvl[i][4] != 0
							player.hrtp.tilesleft = $1 + 1
						end
					end

					// Warp Collision
					if player.hrtp.lvl[i][3] == 2
						if player.hrtp.orbposy < player.hrtp.lvl[i][2] + 56 and player.hrtp.orbposy > player.hrtp.lvl[i][2]
							if player.hrtp.orbposx > player.hrtp.lvl[i][1] - 24 and player.hrtp.orbposx < player.hrtp.lvl[i][1] + 32
								for o=1, 180
									if player.hrtp.lvl[o][3] == 2 and player.hrtp.lvl[o][4] != player.hrtp.lvl[i][4]
										player.hrtp.orbposx = player.hrtp.lvl[o][1]
										player.hrtp.orbposy = player.hrtp.lvl[o][2]
										player.hrtp.orbmomx = P_RandomKey(21) - 10
										player.hrtp.orbmomy = P_RandomKey(21) - 10
										player.hrtp.orbwarpdelay = 20
										break
									end

									player.hrtp.orbposx = player.hrtp.lvl[i][1]
									player.hrtp.orbposy = player.hrtp.lvl[i][2]
									player.hrtp.orbmomx = P_RandomKey(21) - 10
									player.hrtp.orbmomy = P_RandomKey(21) - 10
									player.hrtp.orbwarpdelay = 20

								end
							end
						end
					end

					// Bumper Collision
					if player.hrtp.lvl[i][3] == 3
						if player.hrtp.orbposy < player.hrtp.lvl[i][2] + 41 and player.hrtp.orbposy > player.hrtp.lvl[i][2] - 8
							if player.hrtp.orbposx > player.hrtp.lvl[i][1] - 24 and player.hrtp.orbposx < player.hrtp.lvl[i][1] + 32
								if player.hrtp.lvl[i][4] == 1 or player.hrtp.lvl[i][4] == 2
									if player.hrtp.orbposy - 13 < player.hrtp.lvl[i][2] and player.hrtp.orbmomy > 0
										player.hrtp.orbmomy = !$1 - 2
									elseif player.hrtp.orbposy - 13 > player.hrtp.lvl[i][2] and player.hrtp.orbmomy < 0
										player.hrtp.orbmomy = !$1 + 2
									end
								end

								if player.hrtp.lvl[i][4] == 1 or player.hrtp.lvl[i][4] == 3
									if player.hrtp.orbposx + 13 > player.hrtp.lvl[i][1] and player.hrtp.orbmomx < 0
										player.hrtp.orbmomx = !$1 + 2
									elseif player.hrtp.orbposx + 13 < player.hrtp.lvl[i][1] and player.hrtp.orbmomx > 0
										player.hrtp.orbmomy = !$1 - 2
									end
								end
							end
						end
					end
				end

				//Points items handlers!
				for i=1,100
					if player.hrtp.item[i][1] != 999
						if player.hrtp.item[i][3] == 1
							player.hrtp.item[i][2] = $1 + 2
							if player.hrtp.item[i][2] >= 377
								player.hrtp.item[i][3] = 2
							end
						elseif player.hrtp.item[i][3] == 2
							player.hrtp.item[i][2] = $1 - 4
							if player.hrtp.item[i][2] <= 368
								player.hrtp.item[i][3] = 3
							end
						elseif player.hrtp.item[i][3] == 3
							player.hrtp.item[i][2] = $1 + 4
							if player.hrtp.item[i][2] >= 377
								player.hrtp.item[i][1] = 999
								player.hrtp.item[i][2] = 999
								player.hrtp.itemcombo = 1
							end
						end

						if player.hrtp.item[i][2] > 345
							and player.hrtp.item[i][1] < (player.hrtp.pos + 11) and (player.hrtp.item[i][1] + 23) > (player.hrtp.pos - 10)
							player.hrtp.points = $1 + (player.hrtp.itemcombo * 200)
							player.hrtp.itemcombo = $1 + 1
							player.hrtp.item[i][1] = 999
							player.hrtp.item[i][2] = 999
						end
					end
				end


			// Level's Done!
				if (player.hrtp.tilesleft == 0) and player.hrtp.level != 5
					player.hrtp.level = $1 + 1
					if player.hrtp.overtime == 0
						player.hrtp.points = $1 + (player.hrtp.timer * 20)
					else
						player.hrtp.overtime = 0
					end
					player.hrtp.orbstart = 0
					player.hrtp.orbposx = 600
					player.hrtp.orbposy = 300
					player.hrtp.orbmomx = 0
					player.hrtp.orbmomy = 0
					player.hrtp.pos = 300
					player.hrtp.startdelay = 2*TICRATE
					for i=1, 50 do
						player.hrtp.shotx[i] = 999
						player.hrtp.shoty[i] = 999
					end
					player.hrtp.pregame = 0
					player.hrtp.sliding = 0
					player.hrtp.swing = 0
					player.hrtp.swingtimer = 0
					player.hrtp.timer = 1000
					player.hrtp.harryup = 0
					for i=1,100
						player.hrtp.bullet[i][1] = 999
					end

					if player.hrtp.level == 5
						player.hrtp.bossx = 280
						player.hrtp.bossy = 84
						player.hrtp.timer = 5000
						S_ChangeMusic("POSNEG", true, player)
					end
				end

				//Boss time, bub!
				if player.hrtp.level == 5
					//Attack 1: Phase 1
					if player.hrtp.bossform == 0
						and player.hrtp.bossattack == 1
						and player.hrtp.bosswait == 0
						for i=1,100
							if player.hrtp.bullet[i][1] == 999
								player.hrtp.bullet[i][1] = player.hrtp.bossx + 48
								player.hrtp.bullet[i][2] = player.hrtp.bossy + 48

								if player.hrtp.bosscycle == 1
									player.hrtp.bossgonnaattackx = -4
									player.hrtp.bossgonnaattacky = 1
								end

								if player.hrtp.bosscycle < 6
									player.hrtp.bossgonnaattackx = $1 + 1
									player.hrtp.bossgonnaattacky = $1 + 1
								end

								if player.hrtp.bosscycle >= 6 and player.hrtp.bosscycle != 11
									player.hrtp.bossgonnaattackx = $1 + 1
									player.hrtp.bossgonnaattacky = $1 - 1
								end

								player.hrtp.bullet[i][3] = player.hrtp.bossgonnaattackx
								player.hrtp.bullet[i][4] = player.hrtp.bossgonnaattacky

								player.hrtp.bosscycle = $1 + 1

								player.hrtp.bosswait = 3

								if player.hrtp.bosscycle == 11
									player.hrtp.bossattack = 3
									player.hrtp.bosscycle = 1
									player.hrtp.bosswait = 4*TICRATE
								end
								break
							end
						end
					end

					//Attack 1: Phase 2 - Form R
					if player.hrtp.bossform == 2
						and player.hrtp.bossattack == 1
						and (player.hrtp.bosswait == 0)
						for i=1,100
							if player.hrtp.bullet[i][1] == 999
								if player.hrtp.bossgonnaattacky == 1
									player.hrtp.bossgonnaattackx = P_RandomKey(2)
								end

								player.hrtp.bullet[i][1] = player.hrtp.bossx + 48
								player.hrtp.bullet[i][2] = player.hrtp.bossy + 48

								if player.hrtp.bossgonnaattackx == 0
									player.hrtp.bullet[i][3] = -2
								elseif player.hrtp.bossgonnaattackx == 1
									player.hrtp.bullet[i][3] = 2
								end

								player.hrtp.bullet[i][4] = 2
								player.hrtp.bullet[i][5] = 2

								if player.hrtp.bossgonnaattacky == 3
									player.hrtp.bosswait = 1*TICRATE
									player.hrtp.bosscycle = $1 + 1
									player.hrtp.bossgonnaattacky = 0
								end

								if player.hrtp.bosscycle == 8
									player.hrtp.bossattack = 3
									player.hrtp.bossform = 1
									player.hrtp.bosscycle = 1
									player.hrtp.bosswait = 4*TICRATE
								end

								player.hrtp.bossgonnaattacky = $1 + 1
								break
							end
						end
					end

					//Attack 1: Phase 2 - Form B
					if player.hrtp.bossform == 3
						and player.hrtp.bossattack == 1
						and player.hrtp.bosswait == 0
						for o=1,100
							if player.hrtp.bullet[o][1] == 999
								player.hrtp.bullet[o][1] = player.hrtp.bossx + 48
								player.hrtp.bullet[o][2] = player.hrtp.bossy + 40

								player.hrtp.bullet[o][3] = P_RandomKey(27) - 13
								player.hrtp.bullet[o][4] = -8 //P_RandomKey(11) - 25
								player.hrtp.bullet[o][5] = 1

								player.hrtp.bosscycle = $1 + 1

								player.hrtp.bosswait = 3

								if player.hrtp.bosscycle == 3*TICRATE
									player.hrtp.bossattack = 3
									player.hrtp.bossform = 1
									player.hrtp.bosscycle = 1
									player.hrtp.bosswait = 4*TICRATE
								end

								break
							end
						end
					end

					//Attack 2: Phase 1
					if player.hrtp.bossform == 0
						and player.hrtp.bossattack == 2
						and player.hrtp.bosswait == 0
						for i=1,100
							if player.hrtp.bullet[i][1] == 999
								player.hrtp.bullet[i][1] = player.hrtp.bossx + 48
								player.hrtp.bullet[i][2] = player.hrtp.bossy + 48

								if player.hrtp.bosscycle == 1
									player.hrtp.bossgonnaattackx = -6
									player.hrtp.bossgonnaattacky = 4
								end

								if player.hrtp.bosscycle < 13
									player.hrtp.bossgonnaattackx = $1 + 1
									//player.hrtp.bossgonnaattacky = $1 + 1
								end

								if player.hrtp.bosscycle >= 13 and player.hrtp.bosscycle != 24
									player.hrtp.bossgonnaattackx = $1 - 1
									player.hrtp.bossgonnaattacky = 6
								end

								player.hrtp.bullet[i][3] = player.hrtp.bossgonnaattackx
								player.hrtp.bullet[i][4] = player.hrtp.bossgonnaattacky

								player.hrtp.bosscycle = $1 + 1

								player.hrtp.bosswait = 1

								if player.hrtp.bosscycle == 24
									player.hrtp.bossattack = 3
									player.hrtp.bosscycle = 1
									player.hrtp.bosswait = 4*TICRATE
								end
								break
							end
						end
					end

					//Attack 2: Phase 2 - Form R
					if player.hrtp.bossform == 2
						and player.hrtp.bossattack == 2
						if player.hrtp.bosscycle < 20
							while player.hrtp.pos > player.hrtp.bossx + 48
								player.hrtp.bossx = $1 + 1
							end
							while player.hrtp.pos < player.hrtp.bossx + 48
								player.hrtp.bossx = $1 - 1
							end
						elseif player.hrtp.bossx > 280
							for i=1,20
								player.hrtp.bossx = $1 - 1
								if player.hrtp.bossx == 280
									break
								end
							end
						elseif player.hrtp.bossx < 280
							for i=1,20
								player.hrtp.bossx = $1 + 1
								if player.hrtp.bossx == 280
									break
								end
							end
						end

						if player.hrtp.bosswait == 0
							for o=1,8
								for i=1,100
									if player.hrtp.bullet[i][1] == 999
										player.hrtp.bullet[i][1] = player.hrtp.bossx + 48 + ((o - 4)* 6)
										if o < 10
											player.hrtp.bullet[i][2] = player.hrtp.bossy + 48 + ((o % 4)* 6)
										else
											player.hrtp.bullet[i][2] = player.hrtp.bossy + 74 - ((o % 4)* 6)
										end

										player.hrtp.bullet[i][3] = 0
										player.hrtp.bullet[i][4] = 5

										if o == 8
											player.hrtp.bosscycle = $1 + 1
										end


										player.hrtp.bosswait = 30 - (player.hrtp.bosscycle / 2)

										if player.hrtp.bossx == 280
											player.hrtp.bossattack = 3
											player.hrtp.bossform = 1
											player.hrtp.bosscycle = 1
											player.hrtp.bosswait = 4*TICRATE
										end
										break
									end
								end
							end
						end
					end

					//Attack 2: Phase 2 - Form B
					if player.hrtp.bossform == 3
						and player.hrtp.bossattack == 2
						if player.hrtp.bosscycle == 1
							and player.hrtp.bossx > 0
							player.hrtp.bossx = $1 - 2
						elseif player.hrtp.bosscycle == 1
							and player.hrtp.bossx <= 0
							player.hrtp.bosscycle = 2
						end
						if player.hrtp.bosscycle == 2
							and player.hrtp.bossx < 592
							player.hrtp.bossx = $1 + 2
						elseif player.hrtp.bosscycle == 2
							and player.hrtp.bossx >= 592
							player.hrtp.bosscycle = 3
						end
						if player.hrtp.bosscycle == 3
							and player.hrtp.bossx > 0
							player.hrtp.bossx = $1 - 2
						elseif player.hrtp.bosscycle == 3
							and player.hrtp.bossx <= 0
							player.hrtp.bosscycle = 4
						end
						if  player.hrtp.cycle == 4 and player.hrtp.bossx > 280
							for i=1,20
								player.hrtp.bossx = $1 - 1
								if player.hrtp.bossx == 280
									player.hrtp.bossattack = 3
									player.hrtp.bossform = 1
									player.hrtp.bosscycle = 1
									player.hrtp.bosswait = 4*TICRATE
									break
								end
							end
						elseif player.hrtp.bosscycle == 4 and player.hrtp.bossx < 280
							for i=1,20
								player.hrtp.bossx = $1 + 1
								if player.hrtp.bossx == 280
									player.hrtp.bossattack = 3
									player.hrtp.bossform = 1
									player.hrtp.bosscycle = 1
									player.hrtp.bosswait = 4*TICRATE
									break
								end
							end
						end
						//print(player.hrtp.bosscycle)
						if player.hrtp.bosscycle != 4
							and player.hrtp.bosswait == 0
							for i=1,100
								if player.hrtp.bullet[i][1] == 999
									player.hrtp.bullet[i][1] = player.hrtp.bossx + 48
									player.hrtp.bullet[i][2] = player.hrtp.bossy + 48

									if player.hrtp.bossgonnaattacky == 1
										player.hrtp.bossgonnaattackx = -8
									end

									if player.hrtp.bossgonnaattacky < 16
										player.hrtp.bossgonnaattackx = $1 + 1
									end

									if player.hrtp.bossgonnaattacky >= 16
										player.hrtp.bossgonnaattackx = $1 - 1
									end

									player.hrtp.bullet[i][3] = player.hrtp.bossgonnaattackx
									player.hrtp.bullet[i][4] = 5

									player.hrtp.bossgonnaattacky = $1 + 1

									if player.hrtp.bossgonnaattacky == 32
										player.hrtp.bossgonnaattacky = 1
									end

									player.hrtp.bosswait = 5
									break
								end
							end
						end
					end

					//Attack 3: Phase 1
					if player.hrtp.bossattack == 3
						and player.hrtp.bosswait == 0
						if player.hrtp.bosscycle == 1
							if player.hrtp.bossy < 352
								player.hrtp.bossy = $1 + 16
							elseif player.hrtp.bossy >= 352
								for i=0,20
									for o=1,100
										if player.hrtp.bullet[o][1] == 999
											player.hrtp.bullet[o][1] = player.hrtp.bossx + 48
											player.hrtp.bullet[o][2] = player.hrtp.bossy + 40

											player.hrtp.bullet[o][3] = P_RandomKey(21) - 10
											player.hrtp.bullet[o][4] = P_RandomKey(11) - 25
											player.hrtp.bullet[o][5] = 1

											break
										end
									end
								end

								player.hrtp.bosscycle = 2
							end
						end

						if player.hrtp.bosscycle == 2
							if player.hrtp.bossy > 84
								player.hrtp.bossy = $1 - 8
							elseif player.hrtp.bossy <= 84
								player.hrtp.bossattack = 0
							end
						end
					end

					//Timers
					if player.hrtp.bosswait > 0
						player.hrtp.bosswait = $1 - 1
					end

					if player.hrtp.bossinvinc > 0
						player.hrtp.bossinvinc = $1 - 1
					end

					//AI Controller
					if player.hrtp.bosshealth > 8
						if player.hrtp.bossattack == 0
							and player.hrtp.bossgonnaattackx == 999
							player.hrtp.bossattack = 1
							player.hrtp.bossform = 0
							player.hrtp.bosswait = 2* TICRATE
							player.hrtp.bosscycle = 1
							player.hrtp.bossgonnaattackx = 0
							player.hrtp.bossgonnaattacky = 1
						elseif player.hrtp.bossattack == 0
							player.hrtp.bossattack = P_RandomKey(2) + 1
							player.hrtp.bosswait = 3*TICRATE
							player.hrtp.bosscycle = 1
						end
					end

					if player.hrtp.bosshealth <= 8
						and player.hrtp.bossattack == 0
						player.hrtp.bossform = P_RandomKey(2) + 2
						player.hrtp.bossattack = P_RandomKey(2) + 1
						player.hrtp.bosswait = 3*TICRATE
						player.hrtp.bosscycle = 1
						player.hrtp.bossgonnaattackx = 0
						player.hrtp.bossgonnaattacky = 1
					end

					//Hitting the boss
					if player.hrtp.orbposy > player.hrtp.bossy + 16 and player.hrtp.orbposy - 25 < player.hrtp.bossy + 80
						and player.hrtp.orbposx + 25 > player.hrtp.bossx + 16 and player.hrtp.orbposx < player.hrtp.bossx + 80
						and player.hrtp.bossinvinc == 0
						player.hrtp.orbmomx = !$1
						player.hrtp.bosshealth = $1 - 1
						player.hrtp.bossinvinc = 2*TICRATE
					end

					//GAME SET!
					if player.hrtp.bosshealth == 0
						if player.hrtp.SUGOISpecialStage == 1
							sugoi.AwardEmerald(true)
						end
						for allp in players.iterate
							allp.exiting = 3
						end
						if player.hrtp.givepoints == 1
							P_AddPlayerScore(player, player.hrtp.points)
							player.hrtp.givepoints = 0
						end
						player.hrtp.bosshealth = -1
						player.hrtp = nil
						player.hrtpinit = nil
					end
				end
				//Boss Code End!

				if player.hrtp == nil
					return
				end

				//Bullet Handlers!
				for i=1, 100
					if player.hrtp.bullet[i][1] != 999
						player.hrtp.bullet[i][1] = $1 + player.hrtp.bullet[i][3]
						player.hrtp.bullet[i][2] = $1 + player.hrtp.bullet[i][4]

						if player.hrtp.bullet[i][5] == 1
							player.hrtp.bullet[i][4] = $1 + 1
						end

						if player.hrtp.bullet[i][5] == 2
							if player.hrtp.pos > player.hrtp.bullet[i][1]
								player.hrtp.bullet[i][1] = $1 + 3
							elseif player.hrtp.pos < player.hrtp.bullet[i][1]
								player.hrtp.bullet[i][1] = $1 - 3
							end
						end

						if player.hrtp.bullet[i][1] < 0 or player.hrtp.bullet[i][1] > 640
							player.hrtp.bullet[i][1] = 999
							player.hrtp.bullet[i][2] = 999
						end

						if player.hrtp.bullet[i][2] < 64 or player.hrtp.bullet[i][2] > 400
							player.hrtp.bullet[i][1] = 999
							player.hrtp.bullet[i][2] = 999
						end
					end

					if player.hrtp.bullet[i][1] == 999
						and player.hrtp.bullet[i][5] != 999
						player.hrtp.bullet[i][5] = 999
					end
				end

				// orb physacks

				player.hrtp.orblastx = player.hrtp.orbposx
				player.hrtp.orblasty = player.hrtp.orbposy

				player.nx = player.hrtp.orblastx
				player.ny = player.hrtp.orblasty

				// X Movement
				if player.hrtp.orbstart == 1
					player.hrtp.orbposx = $1 + player.hrtp.orbmomx
				end

				if player.hrtp.gravitydelay == 0
					player.hrtp.gravitydelay = 3
				else
					player.hrtp.gravitydelay = $1 - 1
				end


				// Y Movement and Gravity
				if player.hrtp.orbstart == 1
					player.hrtp.orbposy = $1 + player.hrtp.orbmomy
					if player.hrtp.gravitydelay != 0
						player.hrtp.orbmomy = $1 + player.hrtp.gravity
					end
				end

				// Bouncin' off walls!
				if player.hrtp.orbposx < 0
					or player.hrtp.orbposx > 615
					player.hrtp.orbmomx = !$1 + 1

					while player.hrtp.orbposx < 0
						player.hrtp.orbposx = $1 + 1
					end

					while player.hrtp.orbposx > 615
						player.hrtp.orbposx = $1 - 1
					end
				end

				// ...And the floor!
				if player.hrtp.orbposy > 400
					player.hrtp.orbmomy = !$1 + 6
					if player.hrtp.orbmomy > 0
						player.hrtp.orbmomy = 0
					end

					while player.hrtp.orbposy > 400
						player.hrtp.orbposy = $1 - 1
					end
				end

				//There's a limit, even to obvious lies...
				if player.hrtp.orbposy < 89
					player.hrtp.orbmomy = !$1
					if player.hrtp.orbmomy < 0
						player.hrtp.orbmomy = 0
					end

					while player.hrtp.orbposy < 89
						player.hrtp.orbposy = $1 + 1
					end
				end

				// Player and Orb collisions!

				if player.hrtp.sliding != 0
					for i = 0,25
						if player.hrtp.orbposy <= 400 and player.hrtp.orbposy >= 375
							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 24) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 24)
								if player.hrtp.sliding > 0
									player.hrtp.orbmomx = 10
									player.hrtp.orbmomy = -20
									break
								elseif player.hrtp.sliding < 0
									player.hrtp.orbmomx = -10
									player.hrtp.orbmomy = -20
									break
								end
							end
						end
					end
				end

				// Shot and orb collisions.
				while player.ny != player.hrtp.orbposy

					while player.nx != player.hrtp.orbposx or player.hrtp.orbmomx == 0

						for k,v in ipairs(player.hrtp.shotx)
							if v != 999
								if v + 5 > player.nx and v - 5 < player.nx + 25
									if player.ny - 25 < player.hrtp.shoty[k] and player.ny > player.hrtp.shoty[k] - 16
										if player.hrtp.orbmomy > 0
											if v > player.nx + 13
												player.hrtp.orbmomx = -10
												player.hrtp.orbmomy = -14
												player.hrtp.shotx[k] = 999
												break 3
											elseif v < player.nx + 13
												player.hrtp.orbmomx = 10
												player.hrtp.orbmomy = -14
												player.hrtp.shotx[k] = 999
												break 3
											end
											player.hrtp.orbmomy = -14
											player.hrtp.shotx[k] = 999
											break 3
										elseif player.hrtp.orbmomy < 0
											if player.hrtp.orbmomx > 0
												player.hrtp.orbmomx = -5
												if player.hrtp.orbmomy > -10
													player.hrtp.orbmomy = -10
												end
												player.hrtp.shotx[k] = 999
												break 3
											elseif player.hrtp.orbmomx < 0
												player.hrtp.orbmomx = 5
												if player.hrtp.orbmomy > -10
													player.hrtp.orbmomy = -10
												end
												player.hrtp.shotx[k] = 999
												break 3
											end
										end
									end
								end
							end
						end


						if player.hrtp.orbposx > player.nx
							player.nx = $1 + 1
						elseif player.hrtp.orbposx < player.nx
							player.nx = $1 - 1
						end

						if player.hrtp.orbmomx == 0
							break
						end
					end

					if player.hrtp.orbposy > player.ny
						player.ny = $1 + 1
					elseif player.hrtp.orbposy < player.ny
						player.ny = $1 - 1
					end
				end

				// What gets shot, must go up...!
				for k,v in ipairs(player.hrtp.shotx)
					if v != 999
						player.hrtp.shoty[k] = $1 - 12
					end

					if player.hrtp.shoty[k] < -20
						player.hrtp.shotx[k] = 999
						player.hrtp.shoty[k] = 999
					end
				end


				// Here comes the behemoth Swinging collision code!
				if player.hrtp.swing != 0
					for i = 0,25
						if player.hrtp.orbposy <= 400 and player.hrtp.orbposy >= 358
							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 1) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 1)
								player.hrtp.orbmomx = 0
								if player.hrtp.swing == 1
									player.hrtp.orbmomy = -30
								elseif player.hrtp.swing == 2
									player.hrtp.orbmomy = -8
								end
								break
							end

							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 7) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 7)
								player.hrtp.orbmomx = -2
								if player.hrtp.swing == 1
									player.hrtp.orbmomy = -28
								elseif player.hrtp.swing == 2
									player.hrtp.orbmomy = -8
								end
								if player.hrtp.orbposx > player.hrtp.pos
									player.hrtp.orbmomx = 2
									break
								end
							end

							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 11) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 11)
								player.hrtp.orbmomx = -4
								if player.hrtp.swing == 1
									player.hrtp.orbmomy = -26
								elseif player.hrtp.swing == 2
									player.hrtp.orbmomy = -8
								end
								if player.hrtp.orbposx > player.hrtp.pos
									player.hrtp.orbmomx = 4
									break
								end
							end

							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 15) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 15)
								player.hrtp.orbmomx = -6
								if player.hrtp.swing == 1
									player.hrtp.orbmomy = -24
								elseif player.hrtp.swing == 2
									player.hrtp.orbmomy = -8
								end
								if player.hrtp.orbposx > player.hrtp.pos
									player.hrtp.orbmomx = 6
									break
								end
							end

							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 19) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 19)
								player.hrtp.orbmomx = -8
								if player.hrtp.swing == 1
									player.hrtp.orbmomy = -22
								elseif player.hrtp.swing == 2
									player.hrtp.orbmomy = -8
								end
								if player.hrtp.orbposx > player.hrtp.pos
									player.hrtp.orbmomx = 8
									break
								end
							end

							if (player.hrtp.orbposx + i) > (player.hrtp.pos - 23) and (player.hrtp.orbposx + i) < (player.hrtp.pos + 23)
								player.hrtp.orbmomx = -10
								if player.hrtp.swing == 1
									player.hrtp.orbmomy = -20
								elseif player.hrtp.swing == 2
									player.hrtp.orbmomy = -8
								end
								if player.hrtp.orbposx > player.hrtp.pos
									player.hrtp.orbmomx = 10
									break
								end
							end
						end
					end
				end
			end
		end
	end
end)

local function drawhuddebug(v, player, cam)
v.drawNum(108, 94, player.hrtp.orbposy)
v.drawNum(108, 124, player.hrtp.pos)
v.drawNum(208, 94, player.hrtp.sliding)
end

local function drawhud(v, player, cam)
	if not (mapheaderinfo[gamemap].sugoihrtp)
		return
	end

	if not (player.hrtpinit and player.hrtp != nil)
		return
	end

	local p_hrtpback1 = v.cachePatch("HRTPBAK1")
	local p_hrtpback2 = v.cachePatch("HRTPBAK2")
	local p_hrtpplay = v.cachePatch("HRTPPLAY")
	local p_hrtporb = v.cachePatch("YORB")
	local p_hrtpshot = v.cachePatch("HRTPSHOT")
	local p_hrtpslide = v.cachePatch("HRTPSLID")
	local p_hrtpswing1 = v.cachePatch("HRTPSWG1")
	local p_hrtpswing2 = v.cachePatch("HRTPSWG2")
	local p_hrtpswing3 = v.cachePatch("HRTPSWG3")
	local p_hrtpswing4 = v.cachePatch("HRTPSWG4")
	local p_hrtptile1 = v.cachePatch("HRTPTILE")
	local p_hrtptileflip1 = v.cachePatch("TILEFLP1")
	local p_hrtptileflip2 = v.cachePatch("TILEFLP2")
	local p_hrtptileflip3 = v.cachePatch("TILEFLP3")
	local p_hrtptileflipf = v.cachePatch("TILEFLPF")
	local p_hrtpwarp = v.cachePatch("HRTPWARP")
	local p_hrtpcircbumper = v.cachePatch("HRTPCBUM")
	local p_hrtphorizbumper = v.cachePatch("HRTPHBUM")
	local p_hrtpbullet = v.cachePatch("HRTPBULL")
	local p_hrtpdead = v.cachePatch("HRTPDEAD")
	local p_hrtpdeadsparkle = v.cachePatch("HRDEDSPK")
	local p_invincspark = v.cachePatch("HRTPINVC")
	local p_hrtpboss1 = v.cachePatch("HRTPBOS1")
	local p_hrtpboss1b = v.cachePatch("HRTPBOSB")
	local p_hrtpboss1r = v.cachePatch("HRTPBOSR")
	local p_hrtpitem = v.cachePatch("HRTPITEM")

	local gfxScale = FRACUNIT/2 // Sal: Increase effiency by pre-calculating this
	// Also everything uses V_PERPLAYER now

	v.drawFill(0, 0, 320, 200, 31|V_PERPLAYER)

	if (player.hrtp.lives <= 0)
		if (multiplayer)
			v.drawString(160, 100, "GAME OVER", V_REDMAP|V_PERPLAYER, "center")

			if (netgame)
				v.drawString(160, 110, "Press F12 to watch another player.", V_PERPLAYER, "center")
			end
		end

		return
	end

	if player.hrtp.gravity == 1
		if player.hrtp.level != 5
			v.drawScaled(0, 0, gfxScale, p_hrtpback1, V_PERPLAYER)
		else
			v.drawScaled(0, 0, gfxScale, p_hrtpback2, V_PERPLAYER)
		end
	end

	if player.hrtp.level == 5
		v.drawNum(180, 20, player.hrtp.bosshealth, V_PERPLAYER)
	elseif player.hrtp.harryup == 0
		v.drawNum(180, 20, player.hrtp.timer, V_PERPLAYER)
	else
		v.drawNum(180, 20, 0, V_PERPLAYER)
	end

	v.drawNum(90, 10, player.hrtp.lives, V_PERPLAYER)
	v.drawNum(180, 0, player.hrtp.points, V_PERPLAYER)

	if player.hrtp.bossx != 999
		local bossPatch = nil // Sal: Less duplication this way

		if (player.hrtp.bossform == 0 or player.hrtp.bossform == 1)
			bossPatch = p_hrtpboss1
		elseif player.hrtp.bossform == 3
			bossPatch = p_hrtpboss1b
		elseif player.hrtp.bossform == 2
			bossPatch = p_hrtpboss1r
		end

		if (bossPatch and bossPatch.valid)
			v.drawScaled(gfxScale * player.hrtp.bossx, gfxScale * player.hrtp.bossy, gfxScale, bossPatch, V_PERPLAYER)
		end
	end

	for i=1,180
		local objPatch = nil

		if player.hrtp.lvl[i][3] == 1
			if player.hrtp.lvl[i][4] == 4
				objPatch = p_hrtptile1
			elseif player.hrtp.lvl[i][4] == 3
				objPatch = p_hrtptileflip1
			elseif player.hrtp.lvl[i][4] == 2
				objPatch = p_hrtptileflip2
			elseif player.hrtp.lvl[i][4] == 1
				objPatch = p_hrtptileflip3
			elseif player.hrtp.lvl[i][4] == 0
				objPatch = p_hrtptileflipf
			end
		elseif player.hrtp.lvl[i][3] == 2
			objPatch = p_hrtpwarp
		elseif player.hrtp.lvl[i][3] == 3
			if player.hrtp.lvl[i][4] == 1
				objPatch = p_hrtpcircbumper
			elseif player.hrtp.lvl[i][4] == 2
				objPatch = p_hrtphorizbumper
			end
		end

		if (objPatch and objPatch.valid)
			v.drawScaled(gfxScale * player.hrtp.lvl[i][1], gfxScale * player.hrtp.lvl[i][2], gfxScale, objPatch, V_PERPLAYER)
		end
	end

	for i=1,100
		if player.hrtp.item[i][1] != 999
			v.drawScaled(gfxScale * player.hrtp.item[i][1], gfxScale * player.hrtp.item[i][2], gfxScale, p_hrtpitem, V_PERPLAYER)
		end
	end

	if player.hrtp.invincibility > 0
		v.drawScaled(gfxScale * (player.hrtp.pos + 4), gfxScale * 365, gfxScale, p_invincspark)
		v.drawScaled(gfxScale * (player.hrtp.pos + 14), gfxScale * 378, gfxScale, p_invincspark)
		v.drawScaled(gfxScale * (player.hrtp.pos + 13), gfxScale * 390, gfxScale, p_invincspark)
	end

	if player.hrtp.dead == 0
		local playerPatch = nil
		local playerFlags = V_PERPLAYER

		if player.hrtp.sliding == 0
		and player.hrtp.swing == 0
			playerPatch = p_hrtpplay
		elseif player.hrtp.sliding > 0
			playerPatch = p_hrtpslide
		elseif player.hrtp.sliding < 0
			playerPatch = p_hrtpslide
			playerFlags = $1 | V_FLIP
		elseif player.hrtp.swing == 1
			if player.hrtp.swingtimer > 6
				playerPatch = p_hrtpswing1
			elseif player.hrtp.swingtimer > 4
				playerPatch = p_hrtpswing2
			elseif player.hrtp.swingtimer > 2
				playerPatch = p_hrtpswing3
			elseif player.hrtp.swingtimer > 0
				playerPatch = p_hrtpswing4
			end
		elseif player.hrtp.swing == 2
			playerFlags = $1 | V_FLIP

			if player.hrtp.swingtimer > 6
				playerPatch = p_hrtpswing1
			elseif player.hrtp.swingtimer > 4
				playerPatch = p_hrtpswing2
			elseif player.hrtp.swingtimer > 2
				playerPatch = p_hrtpswing3
			elseif player.hrtp.swingtimer > 0
				playerPatch = p_hrtpswing4
			end
		end

		if (playerPatch and playerPatch.valid)
			v.drawScaled(gfxScale * player.hrtp.pos, gfxScale * 400, gfxScale, playerPatch, playerFlags)
		end
	end

	if player.hrtp.dead == 3
		v.drawScaled(gfxScale * player.hrtp.pos, gfxScale * 400, gfxScale, p_hrtpdead, V_PERPLAYER)
	end

	if player.hrtp.dead > 0 and player.hrtp.dead < 3
		v.drawScaled(gfxScale * player.hrtp.sparkl, gfxScale * 400, gfxScale, p_hrtpdeadsparkle, V_PERPLAYER)
		v.drawScaled(gfxScale * player.hrtp.sparkr, gfxScale * 400, gfxScale, p_hrtpdeadsparkle, V_PERPLAYER)
	end

	v.drawScaled(gfxScale * player.hrtp.orbposx, gfxScale * player.hrtp.orbposy, gfxScale, p_hrtporb, V_PERPLAYER)

	for k,t in ipairs(player.hrtp.shotx)
		if t != 999
			v.drawScaled(gfxScale * player.hrtp.shotx[k], gfxScale * player.hrtp.shoty[k], gfxScale, p_hrtpshot, V_PERPLAYER)
		end
	end

	for i=1,100
		if player.hrtp.bullet[i][1] != 999
			v.drawScaled(gfxScale * player.hrtp.bullet[i][1], gfxScale * player.hrtp.bullet[i][2], gfxScale, p_hrtpbullet, V_PERPLAYER)
		end
	end
end

hud.add(drawhud)
//hud.add(drawhuddebug)
