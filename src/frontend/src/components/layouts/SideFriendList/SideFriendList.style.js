import styled from 'styled-components';

import { breakPoint } from '@utils/constant';

import { Typography } from '@components/cores';

const { queries } = breakPoint;

export default {
  SideFriendListContainer: styled.div`
    width: 200px;
    height: calc(100vh - 60px);
    padding: 25px 0px 25px 20px;
    background-color: #ffffff;
    overflow: auto;
    transition: visibility 225ms, transform 225ms;
    transition-timing-function: cubic-bezier(0, 0, 0.2, 1);

    @media (${queries.laptopMax}) {
      transform: translateX(200px);
      visibility: hidden;
    }
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
