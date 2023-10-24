import os

if 'PERSON_NAME' in os.environ:
	print(f'Hello, {os.environ["PERSON_NAME"]}!')
else:
	print('ENV variable not set!')

