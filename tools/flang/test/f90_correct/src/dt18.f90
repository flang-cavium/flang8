!* Copyright (c) 1998, NVIDIA CORPORATION.  All rights reserved.
!*
!* Licensed under the Apache License, Version 2.0 (the "License");
!* you may not use this file except in compliance with the License.
!* You may obtain a copy of the License at
!*
!*     http://www.apache.org/licenses/LICENSE-2.0
!*
!* Unless required by applicable law or agreed to in writing, software
!* distributed under the License is distributed on an "AS IS" BASIS,
!* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!* See the License for the specific language governing permissions and
!* limitations under the License.
!
!   arrays of derived type

program p
type test
 integer,dimension(:,:),pointer:: mem
end type
integer results(18), expect(18)
integer l1,l2,u1,u2
data expect /1,3,1,3,36,69, 2,3,2,3,45,56, 3,5,3,5,102,135/

type(test)::a(3)

allocate(a(1)%mem(1:3,1:3))
allocate(a(2)%mem(2:3,2:3))
allocate(a(3)%mem(3:5,3:5))

do k = lbound(a,1),ubound(a,1)
 do i = lbound(a(k)%mem,1), ubound(a(k)%mem,1)
  do j = lbound(a(k)%mem,2), ubound(a(k)%mem,2)
   a(k)%mem(i,j) = i*10+j
  enddo
 enddo
enddo

kk = 0
do k = lbound(a,1),ubound(a,1)
 l1 = lbound(a(k)%mem,1)
 u1 = ubound(a(k)%mem,1)
 l2 = lbound(a(k)%mem,2)
 u2 = ubound(a(k)%mem,2)
 kk = kk + 1
 results(kk) = l1
 kk = kk + 1
 results(kk) = u1
 kk = kk + 1
 results(kk) = l2
 kk = kk + 1
 results(kk) = u2
 kk = kk + 1
 results(kk) = sum(a(k)%mem(l1,:))
 kk = kk + 1
 results(kk) = sum(a(k)%mem(:,u2))
enddo

!print *,results
call check( results, expect, 18)
end
