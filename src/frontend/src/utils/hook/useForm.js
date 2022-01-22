import { useEffect, useState } from 'react';
import { ValidationError } from 'yup';

export default function useForm({ initialValues, validSchema }) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState(
    Object.keys(initialValues).reduce((acc, name) => {
      return { ...acc, [name]: false };
    }, {})
  );

  useEffect(() => {}, [validSchema]);

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

  return { values, errors, touched, changeValue, handleInputChange, handleInputBlur };
}
