! Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.


subroutine weird(dummy)
  class(*), target :: dummy(:)
end subroutine weird

program main
  integer(kind=4), pointer :: myptr(:)
  integer :: j
  logical rslt(8), expect(8)
  interface
     subroutine weird(dummy)
       class(*), target :: dummy(:)
     end subroutine weird
  end interface
  allocate(myptr(4))
  myptr = [(111*j, j=1,4)]
  expect = .true.
  do j=1,4
     rslt(j) = (myptr(j) .eq. (111*j))
  enddo
  call weird(myptr)
  do j=1,4
     rslt(j+4) = (myptr(j) .eq. (111*j))
  enddo
  call check(rslt,expect,8)
end program main
