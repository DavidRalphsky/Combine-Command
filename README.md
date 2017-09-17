# Combine-Command
So this was my attempt at creating an RTS in Garry's Mod. It failed. After taking an embarrassing amount of time trying to figure out how to get the selection box working, the problem that made me give up was threefold:
1) Combine Soldiers don't obey movement commands for seemingly no reason (metropolice and others worked fine)
2) NPCs like to wander once they reach their destination. I can fix this by setting their NPC State to NPC_STATE_NONE, but this stops them from being able to attack.
3) Metrocop doesn't want to use the pistol, dunno why. This is probably fixable.

Hopefully this serves as a useful code snippet to someone.
