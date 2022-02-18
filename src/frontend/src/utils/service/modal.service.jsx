import React, { useEffect, useReducer, useContext } from 'react';
import { v4 as uuidv4 } from 'uuid';

import { ModalContext, ModalIdContext } from '@utils/context';

/**
 * 모달 컴포넌트 제어 서비스
 */

const initialModalState = {};
const modalRegister = {};
const symModalId = Symbol('ModalId');

let dispatch = null;

/**
 * 모달 컴포넌트의 uuid를 생성하는 함수
 *
 * @returns {string} uuid
 */

const getUid = () => `modal_${uuidv4()}`;

/**
 * 모달 컴포넌트의 uuid를 반환하는 함수 (컴포넌트의 고유 uuid가 없다면 생성 후 반환)
 *
 * @returns {string} 모달 컴포넌트의 uuid
 */

const getModalId = modal => {
  if (typeof modal === 'string') return modal;
  if (!modalRegister[symModalId]) {
    modal[symModalId] = getUid();
  }
  return modal[symModalId];
};

/**
 * 모달 컴포넌트를 전역 변수 modalRegister에 등록해주는 함수
 *
 * @param {string} id 모달 컴포넌트 uuid
 * @param {React.Component} comp 모달 컴포넌트
 * @param {Object} props 모달 컴포넌트에 전달할 property
 */

const register = (id, comp, props) => {
  if (!modalRegister[id]) {
    modalRegister[id] = { id, comp, props };
  } else {
    modalRegister[id].props = props;
  }
};

/**
 * 모달 컴포넌트의 상태 (열기/닫기)를 변경해주는 useReducer 함수
 *
 * @param {Object} state
 * @param {Object} action
 * @returns {Object}
 */

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

/**
 * 모달 컴포넌트 열기 액션 함수
 *
 * @param {string} modalId 모달 컴포넌트 uuid
 * @param {Object} args 모달 컴포넌트에 전달할 property
 * @returns {Object}
 * type: reducer 액션 타입
 * payload: 액션 실행시 전달해 줄 데이터
 */

const showModal = (modalId, args) => {
  return {
    type: 'show',
    payload: {
      modalId,
      args,
    },
  };
};

/**
 * 모달 컴포넌트 닫기 함수
 *
 * @param {string} modalId 모달 컴포넌트 uuid
 * @returns {Object}
 * type: reducer 액션 타입
 * payload: 액션 실행시 전달해 줄 데이터
 */

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

/**
 * 모달 컴포넌트 제어 커스텀 훅
 *
 */
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

/**
 * 모달로 만들 컴포넌트를 인자로 전달하면 Context API의 제어를 받게되는 컴포넌트를 반환해주는 함수
 *
 * @param {React.Component} 모달로 만들 컴포넌트
 * @returns {React.Component}
 */

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

/**
 * modalRegister에 등록된 모달 컴포넌트 중 열린 상태의 컴포넌트를 반환하는 함수
 *
 * @returns {React.Component}
 */

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

export default { Provider, useModal, create, show, hide };
