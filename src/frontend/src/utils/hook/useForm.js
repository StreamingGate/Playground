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

  const checkError = async () => {
    try {
      await validSchema.validate(values, { abortEarly: false });
    } catch (error) {
      if (error instanceof ValidationError) {
        const validationErrors = {};
        error.inner.forEach(err => {
          validationErrors[err.path] = err.message;
        });

        setErrors(validationErrors);
      }
    }
  };

  useEffect(() => {
    checkError();
  }, [values]);

  const handleInputChange = e => {
    const { name, value } = e.target;
    const newValues = { ...values, [name]: value };

    setValues(newValues);
  };

  const handleInputBlur = e => {
    const { name } = e.target;

    setTouched(prev => ({
      ...prev,
      [name]: true,
    }));
  };

  return { values, errors, touched, handleInputChange, handleInputBlur };
}
