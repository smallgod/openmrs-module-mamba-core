-- $BEGIN

SELECT start_time
INTO @starttime
FROM _mamba_etl_schedule sch
WHERE end_time IS NOT NULL
  AND transaction_status = 'COMPLETED'
ORDER BY id DESC
LIMIT 1;

-- Insert only new records
INSERT INTO mamba_dim_concept_answer (concept_answer_id,
                                      concept_id,
                                      answer_concept,
                                      answer_drug,
                                      incremental_record)
SELECT ca.concept_answer_id AS concept_answer_id,
       ca.concept_id        AS concept_id,
       ca.answer_concept    AS answer_concept,
       ca.answer_drug       AS answer_drug,
       1
FROM mamba_source_db.concept_answer ca
WHERE ca.concept_answer_id NOT IN (SELECT DISTINCT (concept_answer_id) FROM mamba_dim_concept_answer)
  AND ca.date_created >= @starttime;

-- $END