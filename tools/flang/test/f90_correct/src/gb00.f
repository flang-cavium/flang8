** Copyright (c) 1989, NVIDIA CORPORATION.  All rights reserved.
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.

*   Integer arithmetic operations (+, *, - , /), including
*   constant folding.

	program p
    	parameter (n=24)
	integer rslts(N), expect(N)
	data expect / -7, -398, 7, 1,
     +                6, 87, 2, -8,
     +                -8, 73, -4, -2,
     +                -7, 560, -3, 15,
     +                -7, 1, 0, -2,
     +                100000000, 10, 90, -1  /

	data i7, in1, i4, in4, i9 / 7, -1, 4, -4, 9 /

c  tests 1 - 4:  unary minus and plus operators:

 	rslts(1) = -i7
	rslts(2) = +(-398)
  	rslts(3) = -(-(+i7))
  	rslts(4) = -(-1)

c  tests 5 - 8:  plus operator:

   	rslts(5) = i7 + in1
    	rslts(6) = i7 + 80
    	rslts(7) = 3 + in1
     	rslts(8) = -3+(-5)

c  tests 9 - 12:  minus operator:

     	rslts(9) = in1 - i7
     	rslts(10) = 80 - i7
      	rslts(11) = in1 - 3
       	rslts(12) = -5-(-3)

c  tests 13 - 16:  multiply operator:

	rslts(13) = in1 * i7
	rslts(14) = 80 * i7
	rslts(15) = in1 * 3
	rslts(16) = -5 * (-3)

c  tests 17 - 24:  divide operator:

	rslts(17) = i7 / in1
        rslts(18) = i7 / i4
        rslts(19) = 1 / in4
	rslts(20) = (-8) / 3
	rslts(21) = 900000000 / i9
	rslts(22) = -51 / (-5)
        rslts(23) = 900000000 / 10000000
	rslts(24) = i7 / (-4)

c  check results:

	call check(rslts, expect, N)
	end
