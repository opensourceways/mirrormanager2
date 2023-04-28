FROM fedora:37

WORKDIR /src/mirrormanager2

RUN curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py && python3 get-pip.py

COPY . .

RUN python3 -m pip install -r requirements.txt && \
    cp -r mirrormanager2/admin/* /usr/local/lib/python3.11/site-packages/flask_admin/static/


RUN yum install -y git &&  \
    git clone https://pagure.io/pyrpmmd.git &&  \
    cd pyrpmmd &&  \
    python3 setup.py install

CMD ["sleep", "3333"]
