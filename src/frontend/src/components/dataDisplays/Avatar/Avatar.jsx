import React from 'react';
import PropTypes from 'prop-types';

import ProfileDefaultImg from '@assets/image/ProfileDefault.png';
import S from './Avatar.styles';

function Avatar({ className, name, onClick, imgSrc, size }) {
  return (
    <S.AvartarContainer className={className} data-name={name} size={size} onClick={onClick}>
      <img src={imgSrc} alt='profile' />
    </S.AvartarContainer>
  );
}

Avatar.propTypes = {
  className: PropTypes.string,
  name: PropTypes.string,
  imgSrc: PropTypes.string,
  size: PropTypes.oneOf(['xs', 'sm', 'md', 'lg', 'xl']),
  onClick: PropTypes.func,
};

Avatar.defaultProps = {
  className: '',
  name: '',
  imgSrc: ProfileDefaultImg,
  size: 'sm',
  onClick: undefined,
};

export default Avatar;
