import { useState } from 'react';

export default function useForm(initialValues) {
  const [values, setValues] = useState(initialValues);

  const handleInputChange = e => {
    const { name, value } = e.target;
    const newValues = { ...values, [name]: value };

    setValues(newValues);
  };

  return { values, handleInputChange };
}
