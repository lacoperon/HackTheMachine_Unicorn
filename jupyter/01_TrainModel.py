
# coding: utf-8

# ## Train Model

# ### Configure Spark for Your Notebook
# * This examples uses the local Spark Master `--master local[1]`
# * In production, you would use the PipelineIO Spark Master `--master spark://apachespark-master-2-1-0:7077`

# In[1]:


import os

master = '--master local[1]'
#master = '--master spark://apachespark-master-2-1-0:7077'
conf = '--conf spark.cores.max=1 --conf spark.executor.memory=512m'
packages = '--packages com.amazonaws:aws-java-sdk:1.7.4,org.apache.hadoop:hadoop-aws:2.7.1'
jars = '--jars /root/lib/jpmml-sparkml-package-1.0-SNAPSHOT.jar'
py_files = '--py-files /root/lib/jpmml.py'

os.environ['PYSPARK_SUBMIT_ARGS'] = master   + ' ' + conf   + ' ' + packages   + ' ' + jars   + ' ' + py_files   + ' ' + 'pyspark-shell'

print(os.environ['PYSPARK_SUBMIT_ARGS'])


# ### Import Spark Libraries

# In[2]:


from pyspark.ml import Pipeline
from pyspark.ml.feature import RFormula
from pyspark.ml.classification import DecisionTreeClassifier
from pyspark import SparkConf, SparkContext
from pyspark.sql.context import SQLContext


# ### Create Spark Session
# This may take a minute or two.  Please be patient.

# In[3]:


from pyspark.sql import SparkSession

spark_session = SparkSession.builder.getOrCreate()


# ### Read Data from Public S3 Bucket
# * AWS credentials are not needed.
# * We're asking Spark to infer the schema
# * The data has a header
# * Using `bzip2` because it's a splittable compression file format

# In[4]:


df = spark_session.read.format("csv")   .option("inferSchema", "true").option("header", "true")   .load("s3a://datapalooza/R/census.csv")

df.head()


# In[5]:


print(df.count())


# ## Create and Train Spark ML Pipeline

# In[6]:


formula = RFormula(formula = "income ~ .")
classifier = DecisionTreeClassifier()

pipeline = Pipeline(stages = [formula, classifier])
pipeline_model = pipeline.fit(df)
print(pipeline_model)


# ## Export the Spark ML Pipeline

# In[7]:


from jpmml import toPMMLBytes

model = toPMMLBytes(spark_session, df, pipeline_model)
with open('model.spark', 'wb') as fh:
    fh.write(model)
        


# In[8]:


get_ipython().system('ls -al model.spark')


# In[ ]:




