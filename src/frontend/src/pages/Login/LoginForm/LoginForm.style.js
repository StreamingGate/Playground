import styled from 'styled-components';
import { Link } from 'react-router-dom';

import { VerticalLogo } from '@assets/icon';

export default {
  Form: styled.form`
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 347px;
    min-height: 381px;
    padding: 35px 25px 25px;
    border: 1px solid ${({ theme }) => theme.colors.placeHolder};
  `,
  Logo: styled(VerticalLogo)`
    width: 172px;
  `,
  InputContainer: styled.div`
    margin: 30px 0 40px;
    & > input:first-child {
      margin-bottom: 10px;
    }
  `,
  RegisterContainer: styled.div`
    display: flex;
    gap: 5px;
    margin-top: 47px;
  `,
  RegisterLink: styled(Link)`
    color: ${({ theme }) => theme.colors.youtubeBlue};
    text-decoration: none;
  `,
};
