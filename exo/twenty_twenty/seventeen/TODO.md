Need to revisit this once V is not broken with Generics.
I tried to avoid code duplication, but it's hard since the compiler does weird things.
And even with this, it still fucks up.
Giving me functions like this: 
exo__utils__set__Set_T_part_2__Pos4D_has_T_part_1__Pos3D

At this points, I can't even put the exo 17 in the main cli
because it infers things with 16, which uses the Set too :full-moon-with-face:
