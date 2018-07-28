load patients
Personal_Data = table(Gender,Age);
BMI_Data = table(Height,Weight);
BloodPressure = table(Systolic,Diastolic);
T1 = table(LastName,Personal_Data,BMI_Data,BloodPressure);
head(T1,3)