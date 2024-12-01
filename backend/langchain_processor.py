import os
from dotenv import load_dotenv
from langchain.llms import OpenAI
from langchain.chains import LLMChain, SimpleSequentialChain
from langchain.prompts import PromptTemplate
from supabase import create_client

# Load environment variables
load_dotenv()
openai_api_key = os.getenv("OPENAI_API_KEY")
supabase_url = os.getenv("SUPABASE_URL")
supabase_key = os.getenv("SUPABASE_API_KEY")

# Initialize LangChain and Supabase
llm = OpenAI(openai_api_key=openai_api_key,model="gpt-3.5-turbo")
supabase = create_client(supabase_url, supabase_key)

# Step 1: Extract structured data from OCR text
def process_prescription(ocr_text):
    prompt = """
    You are an expert assistant that processes OCR text of medical prescriptions.
    Extract the following information:
    - Patient Name
    - Patient ID
    - Medicines: Name, Dosage, Frequency, Duration
    If any field is missing, return "Not available". Example response:
    {
      "Patient Name": "John Doe",
      "Patient ID": "P12345",
      "Medicines": [
        {"Name": "Paracetamol", "Dosage": "500mg", "Frequency": "Twice daily", "Duration": "5 days"}
      ]
    }
    Input: {ocr_text}
    """
    chain = LLMChain(llm=llm, prompt=PromptTemplate.from_template(prompt))
    return chain.run({"ocr_text": ocr_text})

# Step 2: Store processed data in Supabase
def store_to_supabase(data):
    response = supabase.table("prescriptions").insert(data).execute()
    return response

# Step 3: Full pipeline
def process_and_store(ocr_text):
    structured_data = process_prescription(ocr_text)
    result = store_to_supabase(structured_data)
    return result
