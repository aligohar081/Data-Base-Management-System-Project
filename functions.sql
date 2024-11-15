CREATE OR REPLACE FUNCTION validate_user_login(
    p_uname character varying,
    p_pin character varying
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_userid INTEGER;
BEGIN
    -- Attempt to retrieve the userid for the given username and pin
    SELECT userid INTO v_userid
    FROM public.users
    WHERE uname = p_uname AND pin = p_pin;

    -- If the userid exists, return it; otherwise, return NULL
    IF FOUND THEN
        RETURN v_userid;
    ELSE
        RETURN NULL;
    END IF;
END;
$$;
