import React, { useEffect, useReducer, useContext } from 'react';
import { v4 as uuidv4 } from 'uuid';

import { ModalContext, ModalIdContext } from '@utils/context';

const initialModalState = {};
const modalRegister = {};
const symModalId = Symbol('ModalId');

let dispatch = null;

const getUid = () => `modal_${uuidv4()}`;

const getModalId = modal => {
  if (typeof modal === 'string') return modal;
  if (!modalRegister[symModalId]) {
    modal[symModalId] = getUid();
  }
  return modal[symModalId];
};

const register = (id, comp, props) => {
  if (!modalRegister[id]) {
    modalRegister[id] = { id, comp, props };
  } else {
    modalRegister[id].props = props;
  }
};

const reducer = (state = initialModalState, action) => {
  switch (action.type) {
    case 'show': {
      const { modalId, args } = action.payload;
      return {
        ...state,
        [modalId]: {
          ...state[modalId],
          id: modalId,
          args,
          visible: true,
        },
      };
    }
    default: {
      const { modalId } = action.payload;
      // 생략가능
      if (!state[modalId]) return state;
      return {
        ...state,
        [modalId]: {
          ...state[modalId],
          visible: false,
        },
      };
    }
  }
};

const showModal = (modalId, args) => {
  return {
    type: 'show',
    payload: {
      modalId,
      args,
    },
  };
};

const hideModal = modalId => {
  return {
    type: 'hide',
    payload: {
      modalId,
    },
  };
};

const show = (modal, args) => {
  const modalId = getModalId(modal);

  if (!modalRegister[modalId]) {
    register(modalId, modal, args);
  }
  dispatch(showModal(modalId, args));
};

const hide = modal => {
  const modalId = getModalId(modal);

  dispatch(hideModal(modalId));
};

export const useModal = (...params) => {
  const [modal, args] = params;
  const modals = useContext(ModalContext);
  const contextModalId = useContext(ModalIdContext);

  let modalId = null;
  if (!modal) {
    modalId = contextModalId;
  } else {
    modalId = getModalId(modal);
  }

  useEffect(() => {
    if (!modalRegister[modalId]) {
      register(modalId, modal);
    }
  }, [modalId, modal, args]);

  const modalInfo = modals[modalId];

  return {
    id: modalId,
    args: modalInfo?.args,
    visible: modalInfo?.visible,
    show: args => show(modalId, args),
    hide: () => hide(modalId),
  };
};

const create = Component => {
  return ({ id, ...props }) => {
    const { args } = useModal(id);

    return (
      <ModalIdContext.Provider value={id}>
        <Component {...props} {...args} />
      </ModalIdContext.Provider>
    );
  };
};

const ModalPlaceHolder = () => {
  const modals = useContext(ModalContext);
  const visibleModalIds = Object.keys(modals).filter(id => modals[id].visible);

  const render = visibleModalIds
    .filter(id => modalRegister[id])
    .map(id => ({ id, ...modalRegister[id] }));

  return (
    <>
      {render.map(t => (
        <t.comp key={t.id} id={t.id} {...t.props} />
      ))}
    </>
  );
};

const Provider = ({ children }) => {
  const [modals, dispatchFunc] = useReducer(reducer, initialModalState);

  dispatch = dispatchFunc;

  return (
    <ModalContext.Provider value={modals}>
      {children}
      <ModalPlaceHolder />
    </ModalContext.Provider>
  );
};

export default { Provider, useModal, create };
