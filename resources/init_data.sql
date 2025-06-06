PGDMP         '            
    {            project3    15.4    15.4     1           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            2           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            3           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            4           1262    30538    project3    DATABASE     �   CREATE DATABASE project3 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = icu LOCALE = 'en_US.UTF-8' ICU_LOCALE = 'en-US';
    DROP DATABASE project3;
                postgres    false                        2615    30540    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            5           0    0    SCHEMA public    COMMENT         COMMENT ON SCHEMA public IS '';
                   postgres    false    5            �            1259    30935 	   employees    TABLE     �   CREATE TABLE public.employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    rate integer NOT NULL,
    CONSTRAINT employees_rate_check CHECK ((rate > 0))
);
    DROP TABLE public.employees;
       public         heap    postgres    false    5            �            1259    30956    logs    TABLE     w  CREATE TABLE public.logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_id uuid NOT NULL,
    project_id uuid NOT NULL,
    work_date date NOT NULL,
    work_hours integer NOT NULL,
    required_review boolean DEFAULT false NOT NULL,
    is_paid boolean DEFAULT false NOT NULL
);
    DROP TABLE public.logs;
       public         heap    postgres    false    5            �            1259    30946    projects    TABLE     �   CREATE TABLE public.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    estimated_time integer,
    is_active boolean DEFAULT false NOT NULL
);
    DROP TABLE public.projects;
       public         heap    postgres    false    5            ,          0    30935 	   employees 
   TABLE DATA           :   COPY public.employees (id, name, email, rate) FROM stdin;
    public          postgres    false    214   �       .          0    30956    logs 
   TABLE DATA           x   COPY public.logs (id, created_at, employee_id, project_id, work_date, work_hours, required_review, is_paid) FROM stdin;
    public          postgres    false    216   "       -          0    30946    projects 
   TABLE DATA           G   COPY public.projects (id, name, estimated_time, is_active) FROM stdin;
    public          postgres    false    215   ]       �           2606    30945    employees employees_email_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);
 G   ALTER TABLE ONLY public.employees DROP CONSTRAINT employees_email_key;
       public            postgres    false    214            �           2606    30943    employees employees_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.employees DROP CONSTRAINT employees_pkey;
       public            postgres    false    214            �           2606    30964    logs logs_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.logs DROP CONSTRAINT logs_pkey;
       public            postgres    false    216            �           2606    30955    projects projects_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.projects DROP CONSTRAINT projects_pkey;
       public            postgres    false    215            �           2606    30965    logs logs_employee_uuid    FK CONSTRAINT     ~   ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_employee_uuid FOREIGN KEY (employee_id) REFERENCES public.employees(id);
 A   ALTER TABLE ONLY public.logs DROP CONSTRAINT logs_employee_uuid;
       public          postgres    false    216    214    3479            �           2606    30970    logs logs_project_id    FK CONSTRAINT     y   ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_project_id FOREIGN KEY (project_id) REFERENCES public.projects(id);
 >   ALTER TABLE ONLY public.logs DROP CONSTRAINT logs_project_id;
       public          postgres    false    215    3481    216            ,     x����n#U�ם�����/;):סe;�K3�d@���hx�L&���N�u�q�m!K��n������;F❉T��lPV�Ѧ)��<����{�*w�e�-��.��r��t�i�<��>��̝�~1�PE�Q&�g-p�8��38NP�-�2���C�m��]������K��c��7�z�-݉kG�K��+�Z0�!P>e�r�*����>�_�U����P�U��Z�6�
z���EZ�,�0�0.X
�x�**LD�:aM�%�`��A�SŪ��/���E7�j�&c���4�IPZe���@�"J�\'��C!��;�څy7w�uX##sRa���4�y#�4� r���Ԕ����=��;Zq�rS�ct������E�!��cK�!,�`�ᠲ	�FB��M��]o������a�����-k/��d�'xR"%`��I�h�d�R9�GJ��V�۵��K>�����O֤t��Ngۤj�d9��T�����������C�O��m[�	��|S�p��j��6��_�d�W�Jh"x��(��D�U�|,oZ�4�C�I��6�a��=�ދ@�&l��΢@i�IG(��'>Ƭ��ۼƸ�v�ͩ�Wы,ƭ�9���-D��"�xnB�&_�{l�
�;�d������i;��6��+h2R$ݎ�H%+3��E�>K�uS~�:���o�l8 ��}"��`�]��I{�cLZW�c"j)��"��/!PH� Nq�aJ��/7k�<�-��"_vs�������U��$�H Ќ"�q�<f��<zl1'T6cg���E�a�y�*N����/
�A�7���Cv�)C3#M�qX��͎��C�e7���;C�9�s�� �F�	}�HN9hAY�8K���NC��g��m����<��z�	�e���!&0�&�,�ȣ����o�~�����r�v��"��/�V���$R�Y�X9Q��^�,U�W{��C����L�d6����)�Xv�	G�r���Q��D� �\��5|?���$��-λ��C�U�|�����_�5 &      .   +  x���K��@��� -�xT�Y��� �W��(�:�H��%/��g�����X��gAP:�=�»ϋ��7�;�]���t%^1�nd̈́h؁F4t��~���p_{��CQ,�F����.���7�8z�f7���}@��Ν�?��I�k#,�Y��bR�h۳6$�o=hH�!�r.z��όU��y�h�wě6��_M{��j��S��^���7w0�~8����h_��?iv�p�Y}4��Z��*�ΰ]��t}���EnԺ�\�tNYt��0���@�s�ivI̩���E[�Z�cڻ%����F��Ml���.[���T�l�G�iޞmvG��Ig~��_?ʶ�z=F1�붪%X��t�"��g��ۘ��V1�߲��U9X��U�	�m�أQ����6�Մ����U�Pm©V�B�8��,m����Xo�>^1j���5X~\0A�l��Nc����!k�&$R���I���������?�ʫ�#���½�w��o\���/߸�B��mV��]� N��+S�E�R>��d�Ƀ�������з�      -   �  x�m�KnT1E��U�
�.��ĿZ耔I"�! h�4iuz�Q�	zے���bL�������ա!�Q��l\�-Z��i^�׼�;~��v^�� O|����զ!��=Al(�R���Ȟ�hZ����2V/�ʠ�J0Epc(Z��[�9T�7|?��i+w���BQA ��&��a@!+�\��,��4���f��;_�n����ȇ�`� ��{~v����nG�$��\���j%����܃S�iMt�Ӽ�~����~yN�$z�X��"%��!� �ڬ�>�&%��'����[~/��H�WDȣ��8�V�I��XGAZ�ϜD�8��Q�\�+���3`J�Ԭ�⣇|J�l�^	b!:2�S.�1���$�b�dtyq*�k��	���Z�EzyX��o���86�Lۉ�H�ؖ���b�m��v���P���AԮ����_��)�������H'f     