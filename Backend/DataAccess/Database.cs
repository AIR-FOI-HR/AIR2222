using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class Database
    {
        private string ConnectionString { get; set; }
        private SqlConnection Connection { get; set; }
        private SqlTransaction Transaction { get; set; }
        private bool TransactionBegan { get; set; }
        public Database(string connString)
        {
            ConnectionString = connString;
        }
        public void Connect()
        {
            Connection = new SqlConnection(ConnectionString);
            Connection.Open();
        }
        public void Disconnect()
        {
            if(Connection.State != System.Data.ConnectionState.Closed)
            {
                Connection.Close();
            }
        }
        public void BeginTransaction()
        {
            try
            {
                Transaction = Connection.BeginTransaction();
                TransactionBegan = true;
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
        public void CommitTransaction()
        {
            try
            {
                if (TransactionBegan)
                    Transaction.Commit();
                else if (Transaction != null)
                    Transaction.Commit();
                Transaction = null;
                TransactionBegan = false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void RollbackTransaction()
        {
            try
            {
                if (Transaction != null)
                {
                    try
                    {
                        Transaction.Rollback();
                    }
                    catch { }
                    finally
                    {
                        Transaction = null;
                        TransactionBegan = false;
                    }

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public SqlDataReader ExecuteQuery(string query)
        {
            SqlCommand cmd = Connection.CreateCommand();
            cmd.CommandText = query;
            if (TransactionBegan)
            {
                cmd.Transaction = Transaction;
            }
            return cmd.ExecuteReader();
        }

        public int ExecuteNonQuery(string query)
        {
            SqlCommand cmd = Connection.CreateCommand();
            cmd.CommandText = query;
            if (TransactionBegan)
            {
                cmd.Transaction = Transaction;
            }
            return cmd.ExecuteNonQuery();
        }
        public object ExecuteScalar(string query, object defaultValue = null)
        {
            object returnObject;
            SqlCommand cmd = new SqlCommand();
            if (TransactionBegan)
            {
                cmd.Transaction = Transaction;
            }
            cmd.CommandText = query;
            returnObject = cmd.ExecuteScalar();

            if (returnObject == DBNull.Value || returnObject == null)
                return defaultValue;
            else
                return returnObject;
        }
    }
}
