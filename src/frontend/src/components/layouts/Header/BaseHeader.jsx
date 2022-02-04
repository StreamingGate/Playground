import React, { useContext } from 'react';

import * as S from './Header.style';
import { HeaderContext, MainLayoutContext } from '@utils/context';

import { IconButton } from '@components/buttons';
import {
  Typography,
  HamburgerBar,
  AddEmptyCircle,
  AddFullCircle,
  FullAlarm,
  Alarm,
  Search,
  MyVideo,
  LiveStreaming,
} from '@components/cores';
import SearchForm from './SearchForm';
import ProfileDropdown from './Dropdowns/ProfileDropdown';
import AlarmDropdown from './Dropdowns/AlarmDropdown';

function BaseHeader() {
  const { onToggle } = useContext(HeaderContext);
  const { onToggleSideNav, modalState, onToggleModal } = useContext(MainLayoutContext);

  const handleAddVideoModalClick = e => {
    e.stopPropagation();
  };

  return (
    <>
      <S.HeaderLeftDiv>
        <S.HambergurIconButton onClick={onToggleSideNav}>
          <HamburgerBar />
        </S.HambergurIconButton>
        <S.VerticalLogoIcon />
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
          <S.AddVideoDropdownContainer onClick={handleAddVideoModalClick}>
            {modalState.addVideo && (
              <S.AddVideoMenus>
                <S.AddVideoMenu>
                  <MyVideo />
                  <Typography type='component'>동영상 업로드</Typography>
                </S.AddVideoMenu>
                <S.AddVideoMenu>
                  <LiveStreaming />
                  <Typography type='component'>실시간 스트리밍 시작</Typography>
                </S.AddVideoMenu>
              </S.AddVideoMenus>
            )}
          </S.AddVideoDropdownContainer>
        </div>
        <div>
          <IconButton name='alarm' onClick={onToggleModal}>
            {modalState.alarm ? <FullAlarm /> : <Alarm />}
          </IconButton>
          <AlarmDropdown />
        </div>
        <div>
          <S.HeaderAvatar name='profile' onClick={onToggleModal} />
          <ProfileDropdown />
        </div>
      </S.HeaderRightDiv>
    </>
  );
}

export default BaseHeader;
