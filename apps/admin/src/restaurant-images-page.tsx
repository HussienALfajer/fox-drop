import type { ChangeEvent } from 'react';
import { useTranslation } from 'react-i18next';
import { mediaUrl, type MediaWidth } from './media.js';
import {
  IMAGE_TYPES,
  type ImageRefusal,
  type ImageTarget,
  useSetImage,
} from './restaurant-images.js';

const refusalKeys = {
  type: 'images.refused.type',
  size: 'images.refused.size',
  not_image: 'images.refused.notImage',
  upload_failed: 'images.refused.uploadFailed',
} as const satisfies Record<ImageRefusal, string>;

// An image of a restaurant, a category or an item with its upload (slice 2.5;
// «الصور» itself moved into the restaurant profile, slice 2.30d).
export function ImageField(props: {
  label: string;
  imageKey: string | null;
  width: MediaWidth;
  target: ImageTarget;
  editable: boolean;
}) {
  const { t } = useTranslation();
  const setImage = useSetImage();
  const pick = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = '';
    if (file) setImage.mutate({ target: props.target, file });
  };
  const result = setImage.data;
  return (
    <section aria-label={props.label}>
      <h3>{props.label}</h3>
      {props.imageKey ? (
        <img src={mediaUrl(props.imageKey, props.width)} alt={props.label} width={props.width} />
      ) : (
        <p>{t('images.none')}</p>
      )}
      {props.editable && (
        <label>
          {props.imageKey ? t('images.replace') : t('images.upload')}
          <input
            type="file"
            accept={IMAGE_TYPES.join(',')}
            onChange={pick}
            disabled={setImage.isPending}
          />
        </label>
      )}
      {setImage.isPending ? (
        <p role="status">{t('images.uploading')}</p>
      ) : setImage.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : result?.status === 'refused' ? (
        <p role="alert">{t(refusalKeys[result.refusal])}</p>
      ) : result?.status === 'set' ? (
        <p role="status">{t('images.set')}</p>
      ) : null}
    </section>
  );
}
