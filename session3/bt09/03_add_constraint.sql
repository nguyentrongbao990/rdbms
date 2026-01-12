-- them constraint:
--student_id và course_id trong Enrollments là khóa ngoại
--student_id
alter table enrollments
add constraint fk_enrollments_student
foreign key (student_id)
references students(student_id);
--course_id
alter table enrollments
add constraint fk_enrollments_course
foreign key (course_id)
references courses(course_id);
--grade chỉ được phép là các giá trị A, B, C, D, F
alter table enrollments
add constraint ck_enrollment_grade
check (grade in ('A','B','C','D','F'));