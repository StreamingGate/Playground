import React from 'react';
import { ThemeProvider } from 'styled-components';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

import { GlobalStyle, NormalizeStyle } from '@components/styles';
import { theme } from '@utils/constant';

function App() {
  return (
    <ThemeProvider theme={theme}>
      <GlobalStyle />
      <NormalizeStyle />
      <Router>
        <Routes>
          <Route path='/' element={<Navigate to='/login' />} />
          <Route path='/login' element={<div>TEST</div>} />
        </Routes>
      </Router>
    </ThemeProvider>
  );
}

export default App;
