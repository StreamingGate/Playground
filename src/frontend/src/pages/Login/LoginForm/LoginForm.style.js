import styled from 'styled-components';
import { Link } from 'react-router-dom';

import { breakPoint } from '@utils/constant';

import { Input } from '@components/forms';
import { VerticalLogo } from '@components/cores';

const { queries } = breakPoint;

export default {
  Form: styled.form`
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 347px;
    height: fit-content;
    padding: 35px 25px 25px;
    border: 1px solid ${({ theme }) => theme.colors.placeHolder};
    background-color: #ffffff;

    @media (${queries.mobileMax}) {
      width: 100%;
      height: 100%;
    }
  `,

  Logo: styled(VerticalLogo)`
    width: 172px;
    height: 40px;
  `,

  InputContainer: styled.div`
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 100%;
    margin: 30px 0 40px;
  `,

  LoginInput: styled(Input)`
    border: none;
    background-color: ${({ theme }) => theme.colors.background};
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
