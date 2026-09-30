<?php
// Sets the YunoHost SMTP settings in the wiki, in the defaults of the wikis the farm creates and in the farm wikis.
// Usage, from the install dir: php mail_config.php add <app> <domain> | change_url <app> <old_domain> <new_domain>

require 'includes/entities/ConfigurationFile.php';
require 'includes/services/ConfigurationService.php';

use YesWiki\Core\Service\ConfigurationService;

// the settings a wiki needs to send through the YunoHost mail server with the app system user
function smtpSettings(string $app, string $domain, string $password): array
{
    return [
        'contact_mail_func' => 'smtp',
        'contact_smtp_host' => '127.0.0.1',
        'contact_smtp_port' => '587',
        'contact_smtp_user' => $app,
        'contact_smtp_pass' => $password,
        'contact_smtp_secure' => 'tls',
        'contact_smtp_verify_peer' => false,
        'contact_from' => $app . '@' . $domain,
    ];
}

// adds the settings to a config array unless it already chose its own way of sending mails
function addSettings(array $config, array $settings): array
{
    return isset($config['contact_mail_func']) ? $config : array_merge($config, $settings);
}

// hides the settings from the edit config page of a farm wiki, as the farm does for its extra config
function lockSettings(array $config, array $settings): array
{
    $locked = array_merge((array)($config['edit_config_locked_params'] ?? []), array_keys($settings));
    $config['edit_config_locked_params'] = array_values(array_unique($locked));

    return $config;
}

// replaces the old domain in the sender address this script wrote, leaving hand-made ones alone
function changeDomain(array $config, string $app, string $old, string $new): array
{
    if (($config['contact_from'] ?? '') === $app . '@' . $old) {
        $config['contact_from'] = $app . '@' . $new;
    }

    return $config;
}

[, $mode, $app] = $argv;
$service = new ConfigurationService();
$files = array_merge(['wakka.config.php'], glob('*/wakka.config.php') ?: []);

foreach ($files as $file) {
    $config = $service->getConfiguration($file);
    $config->load();
    $params = $config->_parameters;
    if (empty($params)) {
        continue;
    }
    $isMaster = $file === 'wakka.config.php';

    if ($mode === 'add') {
        $settings = smtpSettings($app, $argv[3], getenv('YNH_MAIL_PWD') ?: '');
        $wasMissing = !isset($params['contact_mail_func']);
        $params = addSettings($params, $settings);
        if (!$isMaster && $wasMissing) {
            $params = lockSettings($params, $settings);
        }
        if ($isMaster && is_dir('tools/ferme')) {
            $params['yeswiki-farm-extra-config'] = addSettings($params['yeswiki-farm-extra-config'] ?? [], $settings);
        }
    } elseif ($mode === 'change_url') {
        $params = changeDomain($params, $app, $argv[3], $argv[4]);
        if ($isMaster && is_array($params['yeswiki-farm-extra-config'] ?? null)) {
            $params['yeswiki-farm-extra-config'] = changeDomain($params['yeswiki-farm-extra-config'], $app, $argv[3], $argv[4]);
        }
    }

    if ($params !== $config->_parameters) {
        foreach ($params as $key => $value) {
            $config->$key = $value;
        }
        $service->write($config);
        echo "Mail settings updated in $file\n";
    }
}
