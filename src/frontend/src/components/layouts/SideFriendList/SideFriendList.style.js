import styled from 'styled-components';

import { Typography } from '@components/cores';

export default {
  SideFriendListContainer: styled.div`
    width: 200px;
    height: calc(100vh - 60px);
    padding: 25px 0px 25px 20px;
    background-color: #ffffff;
    overflow: auto;
  `,
  SideFriendListHeader: styled(Typography)`
    margin-bottom: 15px;
    color: ${({ theme }) => theme.colors.placeHolder};
  `,
  FriendList: styled.ul`
    display: flex;
    flex-direction: column;
    gap: 15px;
  `,
  FriendItem: styled.li`
    display: flex;
    align-items: center;
  `,
  FriendName: styled(Typography)`
    margin-left: 5px;
  `,
};
