import { createGlobalStyle } from 'styled-components';

import robotoRegular from '@assets/font/Roboto-Regular.ttf';
import { breakPoint } from '@utils/constant';

const { queries } = breakPoint;

const GlobalStyle = createGlobalStyle`
    @font-face {
        font-family: 'Roboto';
        src: url(${robotoRegular});
    }

    * {
        font-family: 'Roboto';
    }

    :root {
        --head-height: 60px;
        --side-nav-bar-width: 250px;
        --side-friend-list-width: 200px;
        --head-logo-width: 116px;
        --head-logo-height: 27px;
        --head-logo-margin: 17px;
        --video-num-in-a-row: 4;

        @media(${queries.wideLaptop}) {
            --video-num-in-a-row: 3;
        }

        @media(${queries.tabletMax}) {
            --video-num-in-a-row: 2;
        }

        @media(${queries.mobileMax})  {
            --video-num-in-a-row: 1;
        }
    }

    body {
        background-color: ${props => props.theme.colors.background}
    }
`;

export default GlobalStyle;
