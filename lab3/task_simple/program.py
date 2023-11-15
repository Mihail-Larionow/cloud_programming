import random

with open('/app/result.txt', 'w') as f:
    for _ in range(8):
        f.write(str(random.randint(0, 9)) + '\n')
