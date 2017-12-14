using Glampinho.model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Glampinho.dal;
using System.Data.SqlClient;
using System.Transactions;
using Glampinho.mapper;


namespace Glampinho.mapper
{
    class AlojamentoMapper : AbstracMapper<Alojamento, int?, List<Alojamento>>, IAlojamentoMapper
    {
        public AlojamentoMapper(IContext ctx) : base(ctx) { }

        public override Alojamento Create(Alojamento entity)
        {
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();

                using (IDbCommand cmd = context.createCommand())
                {
                    cmd.CommandText = InsertCommandText;
                    cmd.CommandType = InsertCommandType;
                    InsertParameters(cmd, entity);
                    cmd.ExecuteNonQuery();
                    entity = UpdateEntityID(cmd, entity);
                }
                if (entity != null && entity.)
                {
                    SqlParameter p = new SqlParameter("@courseId", SqlDbType.Int);
                    SqlParameter p1 = new SqlParameter("@studentId", entity.Number);

                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    parameters.Add(p1);
                    foreach (var course in entity.EnrolledCourses)
                    {
                        p.Value = course.Id;
                        ExecuteNonQuery("INSERT INTO StudentCourse (studentId,courseId) values(@studentId,@courseId)", parameters);
                    }

                }
                ts.Complete();
                return entity;
            }

        }

        public override Student Read(int? id)
        {
            TransactionOptions opt = new TransactionOptions();
            opt.IsolationLevel = System.Transactions.IsolationLevel.RepeatableRead;
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required, opt))
            {
                EnsureContext();
                context.EnlistTransaction();
                Student s = null;
                using (IDbCommand cmd = context.createCommand())
                {
                    cmd.CommandText = SelectCommandText;
                    cmd.CommandType = SelectCommandType;
                    SelectParameters(cmd, id);
                    using (IDataReader reader = cmd.ExecuteReader())
                        if (reader.Read())
                        {
                            s = Map(reader);
                            LoadCourses(s);
                        }

                }
                ts.Complete();
                return s;
            }
        }

        public override List<Student> ReadAll()
        {
            TransactionOptions opt = new TransactionOptions();
            opt.IsolationLevel = System.Transactions.IsolationLevel.RepeatableRead;
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required, opt))
            {
                EnsureContext();
                context.EnlistTransaction();
                List<Student> sts;
                using (IDbCommand cmd = context.createCommand())
                {

                    cmd.CommandText = SelectAllCommandText;
                    cmd.CommandType = SelectAllCommandType;
                    SelectAllParameters(cmd);
                    using (IDataReader reader = cmd.ExecuteReader())
                        sts = MapAll(reader);

                    foreach (var student in sts)
                    {
                        LoadCourses(student);
                    }


                }
                ts.Complete();
                return sts;
            }
        }

        public override Student Delete(Student entity)
        {
            if (entity == null)
                throw new ArgumentException("The " + typeof(Student) + " to delete cannot be null");

            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                if (entity.EnrolledCourses != null && entity.EnrolledCourses.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@studentId", entity.Number);

                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from StudentCourse where studentId=@studentId", parameters);
                }

                Student del = base.Delete(entity);
                ts.Complete();
                return del;
            }
        }
        protected override string DeleteCommandText
        {
            get
            {
                return "delete from Student where studentNumber=@id";
            }
        }

        protected override string InsertCommandText
        {
            get
            {
                return "insert into STUDENT(studentNumber,name,sex,dateBirth,country) values(@id,@name,@sex,@dateBirth,@country); select @id=studentNumber from STUDENT;";
            }
        }

        protected override string SelectAllCommandText
        {
            get
            {
                return "select studentNumber,name,sex,dateBirth,country from Student";
            }
        }

        protected override string SelectCommandText
        {
            get
            {
                return String.Format("{0} where studentNumber=@id", SelectAllCommandText);
            }
        }

        protected override string UpdateCommandText
        {
            get
            {
                return "update Student set name=@name, sex=@sex, dateBirth=@dateBirth where studentNumber=@id";
            }
        }

        protected override void DeleteParameters(IDbCommand cmd, Student entity)
        {
            SqlParameter p1 = new SqlParameter("@id", entity.Number);
            cmd.Parameters.Add(p1);
        }

        protected override void InsertParameters(IDbCommand cmd, Student entity)
        {
            UpdateParameters(cmd, entity);
        }

        protected override Student Map(IDataRecord record)
        {
            Student s = new Student();
            s.Number = record.GetInt32(0);
            s.Name = record.GetString(1);
            s.Sex = (record.GetString(2).ToCharArray())[0];
            s.DateOfBirth = record.GetDateTime(3).ToLongDateString();

            CountryMapper countryMap = new CountryMapper(context);
            s.HomeCountry = countryMap.Read(record.GetInt32(4));

            return s;
        }

        protected override void SelectParameters(IDbCommand cmd, int? id)
        {
            SqlParameter p = new SqlParameter("@id", id);
            cmd.Parameters.Add(p);
        }

        protected override Student UpdateEntityID(IDbCommand cmd, Student e)
        {
            var param = cmd.Parameters["@id"] as SqlParameter;
            e.Number = int.Parse(param.Value.ToString());
            return e;
        }

        protected override void UpdateParameters(IDbCommand cmd, Student entity)
        {
            SqlParameter p1 = new SqlParameter("@id", entity.Number);
            SqlParameter p2 = new SqlParameter("@name", entity.Name);
            SqlParameter p3 = new SqlParameter("@sex", entity.Sex);
            SqlParameter p4 = new SqlParameter("@dateBirth", entity.DateOfBirth);
            SqlParameter p5 = new SqlParameter("@country", entity.HomeCountry == null ? null : entity.HomeCountry.Id);
            p1.Direction = ParameterDirection.InputOutput;

            cmd.Parameters.Add(p1);
            cmd.Parameters.Add(p2);
            cmd.Parameters.Add(p3);
            cmd.Parameters.Add(p4);
            cmd.Parameters.Add(p5);
        }
    }
}