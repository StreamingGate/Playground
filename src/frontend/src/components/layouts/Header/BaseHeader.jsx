import React, { useContext } from 'react';
import { useNavigate } from 'react-router-dom';

import * as S from './Header.style';
import { HeaderContext, MainLayoutContext } from '@utils/context';
import { lStorageService } from '@utils/service';

import { IconButton } from '@components/buttons';
import {
  HamburgerBar,
  AddEmptyCircle,
  AddFullCircle,
  FullAlarm,
  Alarm,
  Search,
} from '@components/cores';
import SearchForm from './SearchForm';
import AddVideoDropdown from './Dropdowns/AddVideoDropdown';
import AlarmDropdown from './Dropdowns/AlarmDropdown';
import ProfileDropdown from './Dropdowns/ProfileDropdown';

function BaseHeader() {
  const userProfileImage = lStorageService.getItem('profileImage');
  const navigate = useNavigate();

  const { onToggle } = useContext(HeaderContext);
  const { onToggleSideNav, modalState, onToggleModal } = useContext(MainLayoutContext);

  const handleLogoClick = () => {
    navigate('/home');
  };

  return (
    <>
      <S.HeaderLeftDiv>
        <S.HambergurIconButton onClick={onToggleSideNav}>
          <HamburgerBar />
        </S.HambergurIconButton>
        <S.VerticalLogoIcon onClick={handleLogoClick} />
      </S.HeaderLeftDiv>
      <SearchForm />
      <S.HeaderRightDiv>
        <S.SearchBarIconButton onClick={onToggle}>
          <Search />
        </S.SearchBarIconButton>
        <div>
          <IconButton name='addVideo' onClick={onToggleModal}>
            {modalState.addVideo ? <AddFullCircle /> : <AddEmptyCircle />}
          </IconButton>
          <AddVideoDropdown />
        </div>
        <div>
          <IconButton name='alarm' onClick={onToggleModal}>
            {modalState.alarm ? <FullAlarm /> : <Alarm />}
          </IconButton>
          <AlarmDropdown />
        </div>
        <div>
          <S.HeaderAvatar name='profile' onClick={onToggleModal} imgSrc={userProfileImage} />
          <ProfileDropdown />
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;
