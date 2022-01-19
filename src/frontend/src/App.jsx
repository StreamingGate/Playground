import React from 'react';
import { ThemeProvider } from 'styled-components';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

import { GlobalStyle, NormalizeStyle } from '@components/styles';
import { theme } from '@utils/constant';

import { MainLayout } from '@components/layouts';
import LoginPage from '@pages/Login';
import RegisterPage from '@pages/Register';
import HomePage from '@pages/Home';
import VideoPlayPage from '@pages/VideoPlay';
import ChannelPage from '@pages/Channel';
import MyPage from '@pages/My';

function App() {
  return (
    <ThemeProvider theme={theme}>
      <GlobalStyle />
      <NormalizeStyle />
      <Router>
        <Routes>
          <Route path='/' element={<Navigate to='/login' />} />
          <Route path='/login' element={<LoginPage />} />
          <Route path='/register' element={<RegisterPage />} />
          <Route path='*' element={<MainLayout />}>
            <Route path='home' element={<HomePage />} />
            <Route path='video-play/:id' element={<VideoPlayPage />} />
            <Route path='channel/:id' element={<ChannelPage />} />
            <Route path='mypage/:type' element={<MyPage />} />
          </Route>
        </Routes>
      </Router>
    </ThemeProvider>
  );
}

export default App;
