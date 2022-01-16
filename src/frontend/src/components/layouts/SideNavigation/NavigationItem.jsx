import React, { memo } from 'react';
import PropTypes from 'prop-types';

import { Typography } from '@components/cores';
import S from './SideNavigation.style';

function NavigationItem({ path, itemIcon, fontType, content }) {
  return (
    <li>
      <S.NavigationLink to={path}>
        {itemIcon}
        <Typography type={fontType}>{content}</Typography>
      </S.NavigationLink>
    </li>
  );
}

NavigationItem.propTypes = {
  path: PropTypes.string.isRequired,
  itemIcon: PropTypes.node.isRequired,
  fontType: PropTypes.string.isRequired,
  content: PropTypes.string.isRequired,
};

export default memo(NavigationItem);
