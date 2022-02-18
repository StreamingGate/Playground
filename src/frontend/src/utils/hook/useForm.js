import { useEffect, useState } from 'react';
import { ValidationError } from 'yup';

/**
 * 인풋 컴포넌트 이벤트 처리 커스텀 훅
 *
 * @param {Object} initialValues 인풋 컴포넌트 값 객체
 * @param {Object} validSchema 인풋 컴포넌트 값 유효성 검사 객체 (yup 라이브러리로 생성)
 * @param {Function} onSubmit 폼 컴포넌트 제출 이벤트 발생시 실행 시킬 함수 (handleSumbit 함수 내부에서 실행)
 * @returns {Object}
 * values: 인풋 컴포넌트 값 객체,
 * errors: 유효성 검사 에러 메세지 객체,
 * touched: 인풋 컴포넌트 포커싱 여부 객체,
 * changeValue: 특정 인풋 컴포넌트 값 변경,
 * handleInputChange: 인풋 컴포넌트 변경 이벤트 함수,
 * handleInputBlur: 인풋 컴포넌트 'onBlur' 이벤트 함수,
 * handleSubmit: 인풋 컴포넌트 제출 이벤트 함수
 */

export default function useForm({ initialValues, validSchema, onSubmit }) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  useEffect(() => {
    setTouched(
      Object.keys(initialValues).reduce((acc, name) => {
        return { ...acc, [name]: false };
      }, {})
    );
  }, [validSchema]);

  const checkError = async () => {
    const validationErrors = {};
    try {
      await validSchema.validate(values, { abortEarly: false });
    } catch (error) {
      if (error instanceof ValidationError) {
        error.inner.forEach(err => {
          validationErrors[err.path] = err.message;
        });
      }
    }
    setErrors(validationErrors);
  };

  useEffect(() => {
    if (validSchema) {
      checkError();
    }
  }, [values, validSchema]);

  // args = [[name, value], ...]
  const changeValue = (...args) => {
    const newValues = { ...values };
    args.forEach(([name, value]) => {
      newValues[name] = value;
    });

    setValues(newValues);
  };

  const handleInputChange = e => {
    const { name, value } = e.target;
    changeValue([name, value]);
  };

  const handleInputBlur = e => {
    const { name } = e.target;

    setTouched(prev => ({
      ...prev,
      [name]: true,
    }));
  };

  const handleSubmit = () => {
    const notSubmit = Object.keys(errors).some(fieldName => errors[fieldName]);
    if (notSubmit) {
      const newTouched = { ...touched };
      Object.keys(errors).forEach(fieldName => {
        newTouched[fieldName] = true;
      });
      setTouched(newTouched);
      return;
    }
    if (onSubmit && typeof onSubmit === 'function') {
      onSubmit(values);
    }
  };

  return { values, errors, touched, changeValue, handleInputChange, handleInputBlur, handleSubmit };
}
