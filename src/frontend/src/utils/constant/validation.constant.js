import * as yup from 'yup';

const register = [
  yup.object().shape({
    name: yup
      .string()
      .required('이름을 입력해 주세요')
      .matches(/[가-힣A-Za-z ]{1,}/, '본명을 입력해 주세요'),
    email: yup
      .string()
      .required('이메일을 입력해 주세요')
      .email('올바른 이메일 형식을 입력해 주세요'),
    verify: yup.string().required('인증번호를 입력해 주세요'),
  }),
  yup.object().shape({
    nickName: yup
      .string()
      .required('닉네임을 입력해 주세요')
      .max(8, '최대 8글자까지 입력하실 수 있습니다'),
  }),
  yup.object().shape({
    password: yup
      .string()
      .required('비밀번호를 입력해 주세요')
      .matches(
        /^(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,16}$/,
        '영문 소문자와 숫자를 포함한 6~16자여야 합니다'
      ),
    passwordCheck: yup.string().oneOf([yup.ref('password'), null], '비밀번호가 일치하지 않습니다'),
  }),
];

const login = yup.object().shape({
  email: yup
    .string()
    .required('이메일을 입력해 주세요')
    .email('올바른 이메일 형식을 입력해 주세요'),
  password: yup
    .string()
    .required('비밀번호를 입력해 주세요')
    .matches(
      /^(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,16}$/,
      '영문 소문자와 숫자를 포함한 6~16자여야 합니다'
    ),
});

const modifyProfile = yup.object().shape({
  nickName: yup
    .string()
    .required('닉네임을 입력해 주세요')
    .max(8, '최대 8글자까지 입력하실 수 있습니다'),
});

export default { register, login, modifyProfile };
